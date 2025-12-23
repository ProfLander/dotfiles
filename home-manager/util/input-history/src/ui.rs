use serde::{Deserialize, Serialize};
use std::marker::PhantomData;
use nu_ansi_term::AnsiString;

#[derive(Debug, Copy, Clone, Serialize, Deserialize)]
pub enum Width {
    Fixed(usize),
    Fill
}

#[derive(Debug, Copy, Clone, Serialize, Deserialize)]
pub enum Height {
    Fixed(usize),
    Fill,
    Auto,
}

impl Width {
    pub fn unwrap_fixed(self) -> usize {
        match self {
            Width::Fixed(width) => width,
            Width::Fill => panic!("Width is not fixed"),
        }
    }
}

pub trait DisplayWidth {
    fn width(&self) -> Width;
}

impl DisplayWidth for char {
    fn width(&self) -> Width {
        self.to_string().width()
    }
}

impl DisplayWidth for &'_ str {
    fn width(&self) -> Width {
        Width::Fixed(utf8_slice::len(self))
    }
}

impl DisplayWidth for String {
    fn width(&self) -> Width {
        Width::Fixed(utf8_slice::len(self))
    }
}

impl DisplayWidth for AnsiString<'_> {
    fn width(&self) -> Width {
        Width::Fixed(utf8_slice::len(self.as_str()))
    }
}

impl<T> DisplayWidth for &T where T: DisplayWidth {
    fn width(&self) -> Width {
        (*self).width()
    }
}

impl<T, L, R> DisplayWidth for Cell<T, L, R> {
    fn width(&self) -> Width {
        Width::Fill
    }
}

impl<T> DisplayWidth for Fill<T> {
    fn width(&self) -> Width {
        Width::Fill
    }
}

pub trait DisplaySlice<'a> {
    type Slice;
    fn slice(&'a self, start: usize, end: usize) -> Self::Slice;
}

impl<'a, T> DisplaySlice<'a> for &'_ T where T: DisplaySlice<'a> {
    type Slice = T::Slice;

    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        (*self).slice(start, end)
    }
}

impl<'a> DisplaySlice<'a> for &'_ str {
    type Slice = &'a str;
    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        &self[start..end]
    }
}

impl<'a> DisplaySlice<'a> for String {
    type Slice = &'a str;
    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        &self[start..end]
    }
}

impl<'a> DisplaySlice<'a> for AnsiString<'_> {
    type Slice = Self;
    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        self.style_ref().paint(self.as_str()[start..end].to_string())
    }
}

pub struct Left;
pub struct Right;

#[derive(Debug, Clone)]
pub struct Cell<D, L, R> {
    align: PhantomData<D>,
    left: L,
    right: R,
}

impl<L, R> std::fmt::Display for Cell<Left, L, R>
where
    L: std::fmt::Display + DisplayWidth,
    R: std::fmt::Display + DisplayWidth,
{
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let width = f.width().unwrap_or_default();
        let width = (width as isize
            - self.right.width().unwrap_fixed() as isize)
            .max(0) as usize;
        write!(f, "{:width$}", self.left)?;
        write!(f, "{}", self.right)
    }
}

impl<L, R> std::fmt::Display for Cell<Right, L, R>
where
    L: std::fmt::Display + DisplayWidth,
    R: std::fmt::Display + DisplayWidth,
{
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let width = f.width().unwrap_or_default();
        let width = (width as isize - self.left.width().unwrap_fixed() as isize).max(0) as usize;
        write!(f, "{}", self.left)?;
        write!(f, "{:width$}", self.right)
    }
}

pub type Snoc<L, R> = Cell<Left, L, R>;
pub type Cons<L, R> = Cell<Right, L, R>;

pub fn snoc<L, R>(l: L, r: R) -> Snoc<L, R> {
    Snoc::new(l, r)
}

pub fn cons<L, R>(l: L, r: R) -> Cons<L, R> {
    Cons::new(l, r)
}

#[macro_export]
macro_rules! cons {
    ($item:expr, $($rest:expr),* $(,)?) => {
        $crate::ui::cons($item, $crate::cons!($($rest),*))
    };
    ($item:expr) => {
        $item
    };
}

#[macro_export]
macro_rules! snoc {
    ($head:expr, $($tail:expr),+ $(,)?) => {
        $crate::snoc!(@accum $head, $($tail),+)
    };

    (@accum $acc:expr, $next:expr, $($rest:expr),+) => {
        $crate::snoc!(@accum $crate::ui::snoc($acc, $next), $($rest),+)
    };

    (@accum $acc:expr, $next:expr) => {
        $crate::ui::snoc($acc, $next)
    };

    ($item:expr) => {
        $item
    };
}

#[macro_export]
macro_rules! bracket {
    ($l:expr, $m:expr, $r:expr) => {
        crate::cons!($l, crate::snoc!($m, $r))
    };
}

#[macro_export]
macro_rules! bracket_fill {
    ($l:expr, $m:expr, $r:expr) => {
        crate::bracket!($l, crate::ui::fill($m), $r)
    };
}

impl<T, L, R> Cell<T, L, R> {
    pub fn new(left: L, right: R) -> Cell<T, L, R> {
        Cell {
            align: Default::default(),
            left,
            right,
        }
    }
}

pub struct Truncate<D, L, R> {
    direction: PhantomData<D>,
    width: usize,
    left: L,
    right: R,
}

pub fn trunc_l<L, R>(left: L, width: usize, right: R) -> Truncate<Left, L, R> {
    Truncate {
        direction: Default::default(),
        width,
        left,
        right,
    }
}

pub fn trunc_r<L, R>(left: L, width: usize, right: R) -> Truncate<Right, L, R> {
    Truncate {
        direction: Default::default(),
        width,
        left,
        right,
    }
}

impl<L, R> std::fmt::Display for Truncate<Left, L, R>
where
    R: std::fmt::Display + DisplayWidth + for<'a> DisplaySlice<'a>,
    for<'a> <R as DisplaySlice<'a>>::Slice: std::fmt::Display,
    L: std::fmt::Display + DisplayWidth,
{
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let left_width = self.left.width().unwrap_fixed();
        let right_width = self.right.width().unwrap_fixed();

        if right_width > self.width {
            let trunc_width = self.width as isize - left_width as isize;
            if trunc_width >= left_width as isize {
                write!(f, "{}{}", self.left, self.right.slice((right_width as isize - trunc_width) as usize, right_width))
            }
            else {
                Ok(())
            }
        }
        else {
            write!(f, "{}", self.right)
        }
    }
}

impl<L, R> std::fmt::Display for Truncate<Right, L, R>
where
    L: std::fmt::Display + DisplayWidth + for<'a> DisplaySlice<'a>,
    for<'a> <L as DisplaySlice<'a>>::Slice: std::fmt::Display,
    R: std::fmt::Display + DisplayWidth,
{
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let left_width = self.left.width().unwrap_fixed();
        let right_width = self.right.width().unwrap_fixed();

        if left_width > self.width {
            let trunc_width = self.width as isize - right_width as isize;
            if trunc_width >= 0 {
                write!(f, "{}{}", self.left.slice(0, trunc_width as usize), self.right)
            }
            else {
                Ok(())
            }
        }
        else {
            write!(f, "{}", self.left)
        }
    }
}

impl<L, R> DisplayWidth for Truncate<Left, L, R> where R: DisplayWidth {
    fn width(&self) -> Width {
        Width::Fixed(self.right.width().unwrap_fixed().min(self.width))
    }
}

impl<L, R> DisplayWidth for Truncate<Right, L, R> where L: DisplayWidth {
    fn width(&self) -> Width {
        Width::Fixed(self.left.width().unwrap_fixed().min(self.width))
    }
}

#[derive(Debug, Default, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Fill<T>(pub T);

impl<T> std::fmt::Display for Fill<T>
where
    T: ToString,
{
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let width = f.width().unwrap_or_default();
        let fill = self.0.to_string();
        f.write_str(&fill.repeat(width))
    }
}


pub fn fill<T>(t: T) -> Fill<T> {
    Fill(t)
}

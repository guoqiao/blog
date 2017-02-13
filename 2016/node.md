Title: Modern Javascript Notes

## Node

create node package:

    mkdir demo
    cd demo
    npm init

install package:

    npm install left-pad
    ls node_modules
    less package.json

install package and save to package.json:

    npm install left-pad --save

install packages from package.json:

    rm -rf node_modules
    npm install

## ES6

map:

    map([1, 2, 3], double)
    [2, 4, 6]

filter:

    map([1, 2, 3], is_odd)
    [1, 3]

reduce:

    map([1, 2, 3], sum)
    6

## Arrow function

    let square = x => x * x;
    let add = (a, b) => a + b;

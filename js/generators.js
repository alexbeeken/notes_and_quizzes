function * generateForLoop(num) {
  for (let i = 0; i < num; i++) {
    yield console.log(i);
  }
}

const genForLoop = generateForLoop(5);

genForLoop.next();
genForLoop.next();
genForLoop.next();
genForLoop.next();
// just ignores more next calls
genForLoop.next();
genForLoop.next();
genForLoop.next();

class JsStudy {
  * generator() {
    // generator code
  }
}

// looking at yeild keyword now

function * withYield(a) {
  let b = 5;
  yield a + b;
  b = 6; // it will be re-assigned after first execution
  yield a * b;
}

const genExample = withYield(10);

console.log(genExample.next().value);
console.log(genExample.next().value);


function * generator() {
  yield 1;
  return 2;
  yield 3; // we will never reach this yield
}

const gen = generator();

console.log(gen.next());
console.log(gen.next());
console.log(gen.next());



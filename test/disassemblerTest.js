const chai    = require('chai');
const expect  = chai.expect;
const spies = require('chai-spies');
chai.use(spies);

const Disassembler = require('../app/lib/disassembler');

describe('Disassembler', function() {
  const disassembler = new Disassembler({logger: console, guid: '232'});

  it('can disassemble', function(done) {
    const code = `%% Demo
-module(hello).
-export([hello_world/0]).

hello_world() -> io:fwrite("hello, world").`;
    const after = (obj) => {
      expect(obj.result).to.not.be.null;
      expect(obj.error).to.be.undefined;
      done();
    };
    disassembler.run(code, after);
  });

  it('can handle errors', function(done) {
    const code = `this is not valid code`;
    const after = (obj) => {
      expect(obj.error).to.not.be.null;
      expect(obj.result).to.be.undefined;
      done();
    };
    disassembler.run(code, after);
  });
});

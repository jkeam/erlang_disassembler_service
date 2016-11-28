const chai    = require("chai");
const expect  = chai.expect;
const spies = require('chai-spies');
chai.use(spies);

// use null logger
const winston = require('winston');
const logger  = new (winston.Logger)({
  transports: []
});

const Disassembler = require("../app/lib/disassembler");

describe("Disassembler", function() {
  const disassembler = new Disassembler(logger);

  it("can disassemble", function(done) {
    const code = "puts 'hi'"

    disassembler.disassemble({code}).then((obj) => {
      expect(obj.result).to.not.be.null;
      done();
    }).catch((e) => {
      done(e);
    })
  });

});

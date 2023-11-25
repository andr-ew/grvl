Engine_Grvl : CroneEngine {

    var grvl;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
        grvl = Grvl.new();

        grvl.commands.keysValuesDo({ arg name, command;
            this.addCommand(name, command.at('format'), command.at('oscFunc'));
        });
        grvl.polls.keysValuesDo({ arg name, poll;
            this.addPoll(name, poll.at('func'));
        });
    }

    free {
        grvl.free;
    }
}

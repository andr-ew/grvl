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

        //TODO: add polls
    }

    free {
        grvl.free;
    }
}

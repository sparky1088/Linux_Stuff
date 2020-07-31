(function($) {

	// define main SpinWheel constructor function
	var SpinWheel = function($canvas, config ) {

		// validate config
		// 1: reject invalids
		for (configKey in config) {
			if (!config.hasOwnProperty(configKey)) continue;
			if (!SpinWheel.config.hasOwnProperty(configKey)) throw 'error: invalid config key "'+configKey+'" in SpinWheel instantiation.';
		} // end for
		// 2: check for requireds
		var requiredParams = ['segmentTexts'];
		for (var i = 0; i < requiredParams.length; ++i) {
			var requiredParam = requiredParams[i];
			if (!config.hasOwnProperty(requiredParam)) throw 'error: missing required config key \''+requiredParam+'\' in SpinWheel instantiation.';
		} // end for

		// store the per-instance config on the "this" object
		this.config = config;

		// capture the canvas jQuery object and init the canvas context
		// note: there should only ever be one SpinWheel instantiated per canvas, and there's only one canvas manipulated by a single SpinWheel instance
		this.$canvas = $canvas;
		this.canvasCtx = this.$canvas[0].getContext("2d");

		// initialize the segments, colors, and curAngle -- wrap this in a function for reusability
		this.reset();

	}; // end SpinWheel()

	// SpinWheel statics
	/*  ---  please look at the index.html source in order to understand what they do ---
		*  outerRadius : the big circle border
		*  innerRadius  : the inner circle border
		*  textRadius   : How far the the text on the wheel locate from the center point
		*  spinTrigger  : the element that trigger the spin action
		*  wheelBorderColor : what is the wheel border color
		*  wheelBorderWidth : what is the "thickness" of the border of the wheel
		*  wheelTextFont : what is the style of the text on the wheel
		*  wheelTextColor : what is the color of the tet on the wheel
		*  wheelTextShadow : what is the shadow for the text on the wheel
		*  resultTextFont : it is not being used currently
		*  arrowColor : what is the color of the arrow on the top
		*  joiner : usually a form input where user can put in their name
		*  addTrigger : what element will trigger the add participant
		*  winnerDiv : the element you want to display the winner
		*/
	SpinWheel.config = {
		'segmentTexts':['1','2','3','4','5','6'],
		'colors':[], // we'll allow omitted config colors; will just generate unspecifieds randomly on-the-fly whenever the wheel is reset
		'outerRadius':200,
		'innerRadius':3,
		'textRadius':160,
		'spinTrigger':'.spin-trigger',
		'wheelBorderColor':'black',
		'wheelBorderWidth':3,
		'wheelTextFont': 'bold 15px sans-serif',
		'wheelTextColor':'black',
		'wheelTextShadowColor':'rgb(220,220,220)',
		'resultTextFont':'bold 30px sans-serif',
		'arrowColor':'black',
		'addTrigger':'.add',
		'deleteTrigger':'.delete',
		'clearTrigger':'.clear',
		'resetTrigger':'.reset',
		'joiner':'.joiner',
		'colorer':'.colorer',
		'winnerDiv':'.winner'
	};

	// SpinWheel instance methods
	SpinWheel.prototype.getConfig = function(key) {
		if (this.config.hasOwnProperty(key)) return this.config[key]; // per-instance config
		if (SpinWheel.config.hasOwnProperty(key)) return SpinWheel.config[key]; // default static config
		throw 'error: invalid config key "'+key+'" requested from SpinWheel::getConfig().';
	} // end SpinWheel::getConfig()

	SpinWheel.prototype.init = function() {
		this.setup();
		this.drawWheel();
	}; // end SpinWheel::init()

	SpinWheel.prototype.setup = function() {

		var thisClosure = this; // necessary to allow callback functions to access the SpinWheel instance

		$(this.getConfig('spinTrigger')).bind('click', function(ev) { (function(ev, target ) {
			ev.preventDefault();
			this.spin();
		}).call(thisClosure, ev, this ); } );

		$(this.getConfig('addTrigger')).bind('click', function(ev) { (function(ev, target ) {
			ev.preventDefault();
			//var item = $('<li/>').append($(this.getConfig('joiner')).val());
			//$(params.paricipants).append(item);
			var $joiner = $(this.getConfig('joiner'));
			var text = $joiner.val();
			if (text) { // don't add a segment with empty text
				var $color = $(this.getConfig('colorer'));
				var color = $color.find('option:selected').text();
				this.add(text, color );
				this.drawWheel();
			} // end if
		}).call(thisClosure, ev, this ); } );

		$(this.getConfig('deleteTrigger')).bind('click', function(ev) { (function(ev, target ) {
			ev.preventDefault();
			var $joiner = $(this.getConfig('joiner')); // reuse joiner input box
			var text = $joiner.val();
			if (text) { // don't delete with empty pattern
				this.del(new RegExp(text));
				this.drawWheel();
			} // end if
		}).call(thisClosure, ev, this ); } );

		$(this.getConfig('clearTrigger')).bind('click', function(ev) { (function(ev, target ) {
			ev.preventDefault();
			this.clear();
			this.drawWheel();
		}).call(thisClosure, ev, this ); } );

		$(this.getConfig('resetTrigger')).bind('click', function(ev) { (function(ev, target ) {
			ev.preventDefault();
			this.reset();
			this.drawWheel();
		}).call(thisClosure, ev, this ); } );

	}; // end SpinWheel::setup()

	SpinWheel.prototype.clear = function() {

		// clear primary wheel state data
		this.segmentTexts = [];
		this.colors = [];
		this.curAngle = 0;

		// also, in case there was a spin in-progress, stop it
		this.stopRotateWheel();

	}; // end SpinWheel::clear()

	SpinWheel.prototype.reset = function() {

		// precomputations
		var segmentTexts = this.getConfig('segmentTexts');
		var colors = this.getConfig('colors');

		// copy the configured segment texts to an instance attribute; this distinction is necessary, since we allow the user to manipulate the segments after initial configuration / resetting
		this.segmentTexts = segmentTexts.slice();

		// generate initial colors
		this.colors = [];
		for (var i = 0; i < this.segmentTexts.length; ++i)
			this.colors.push(colors.length > i ? colors[i] : this.genHexColor());

		// initialize curAngle, which must always exist and track the current angle of the wheel
		this.curAngle = 0;

		// also, in case there was a spin in-progress, stop it
		this.stopRotateWheel();

	}; // end SpinWheel::reset()

	SpinWheel.prototype.add = function(text, color ) {
		// translate color 'auto' to a generated color
		// also take anything invalid as auto
		if (!color || color === 'auto')
			color = this.genHexColor();
		// we just store the text of each segment on the segmentTexts array
		this.segmentTexts.push(text);
		this.colors.push(color);
	}; // end SpinWheel::add()

	SpinWheel.prototype.del = function(pattern) {
		for (var i = 0; i < this.segmentTexts.length; ++i) {
			if (this.segmentTexts[i].match(pattern)) {
				this.segmentTexts.splice(i, 1 );
				if (this.colors.length > i) this.colors.splice(i, 1 ); // colors array can be short
				--i;
			} // end if
		} // end for
	}; // end SpinWheel::del()

	SpinWheel.prototype.spin = function() {
		// the following are per-spin ad hoc state vars that are initialized for each spin, thus there's no point in storing values for them on the config struct
		this.spinAngleStart = Math.random()*10 + 10;
		this.spinTimeTotal = Math.random()*3 + 4*1000;
		this.spinTime = 0;
		this.rotateWheel();
	}; // end SpinWheel::spin()

	SpinWheel.prototype.genHexColor = function() {

		var hexDigits = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];

		// 6 digits in a hex color spec
		var hexColor = '#';
		for (var i = 0; i < 6; ++i)
			hexColor = hexColor+hexDigits[Math.round(Math.random()*15)];

		return hexColor;

	}; // end SpinWheel::genHexColor()

	SpinWheel.prototype.rotateWheel = function() {

		// advance time
		this.spinTime += 30;

		// check for completion
		if (this.spinTime >= this.spinTimeTotal) {
			this.finishSpin();
			return;
		} // end if

		// advance angle
		var x = this.spinAngleStart - this.easeOut(this.spinTime, 0, this.spinAngleStart, this.spinTimeTotal );
		this.curAngle += (x*Math.PI/180);

		// redraw
		this.drawWheel();

		// schedule next rotation
		this.spinTimeout = setTimeout(this.rotateWheel.bind(this), 30 );

	}; // end SpinWheel::rotateWheel()

	SpinWheel.prototype.finishSpin = function() {

		// stop the rotation timeout chain
		this.stopRotateWheel();

		// precomputations
		var segmentNum = this.segmentTexts.length;
		var arc = 2*Math.PI/segmentNum;

		// hit segment calc
		var degrees = this.curAngle*180/Math.PI + 90;
		var arcd = arc*180/Math.PI;
		var index = Math.floor((360 - degrees%360)/arcd);

		// update the display
		this.canvasCtx.save();
		this.canvasCtx.font = this.getConfig('resultTextFont');
		var text = this.segmentTexts[index];
		$(this.getConfig('winnerDiv')).html(text).show();
		//canvasCtx.fillText(text, 250 - canvasCtx.measureText(text).width / 2, 250 + 10);
		this.canvasCtx.restore();

	}; // end SpinWheel:finishSpin()

	SpinWheel.prototype.stopRotateWheel = function() {

		// clear any existing timeout
		if (this.spinTimeout) {
			clearTimeout(this.spinTimeout);
			this.spinTimeout = null;
		} // end if

	}; // end SpinWheel::stopRotateWheel()

	SpinWheel.prototype.drawArrow = function() {
		this.canvasCtx.fillStyle = this.getConfig('arrowColor');
		var outerRadius = this.getConfig('outerRadius');
		this.canvasCtx.beginPath();
		this.canvasCtx.moveTo(250-4, 250-(outerRadius+15) );
		this.canvasCtx.lineTo(250+4, 250-(outerRadius+15) );
		this.canvasCtx.lineTo(250+4, 250-(outerRadius-15) );
		this.canvasCtx.lineTo(250+9, 250-(outerRadius-15) );
		this.canvasCtx.lineTo(250+0, 250-(outerRadius-23) );
		this.canvasCtx.lineTo(250-9, 250-(outerRadius-15) );
		this.canvasCtx.lineTo(250-4, 250-(outerRadius-15) );
		this.canvasCtx.lineTo(250-4, 250-(outerRadius+15) );
		this.canvasCtx.fill();
	}; // end SpinWheel::drawArrow()

	SpinWheel.prototype.drawWheel = function() {

		// precomputations
		var outerRadius = this.getConfig('outerRadius');
		var innerRadius = this.getConfig('innerRadius');
		var textRadius = this.getConfig('textRadius');
		var segmentNum = this.segmentTexts.length;
		var arc = 2*Math.PI/segmentNum;

		// init canvas
		this.canvasCtx.strokeStyle = this.getConfig('wheelBorderColor');
		this.canvasCtx.lineWidth = this.getConfig('wheelBorderWidth');
		this.canvasCtx.font = this.getConfig('wheelTextFont');
		this.canvasCtx.clearRect(0,0,500,500);

		// draw each segment
		for (var i = 0; i < segmentNum; ++i) {
			var text = this.segmentTexts[i];
			var angle = this.curAngle + i*arc;
			this.canvasCtx.fillStyle = this.colors[i];
			this.canvasCtx.beginPath();
			// ** arc(centerX, centerY, radius, startingAngle, endingAngle, antiClockwise);
			this.canvasCtx.arc(250, 250, outerRadius, angle, angle + arc, false );
			this.canvasCtx.arc(250, 250, innerRadius, angle + arc, angle, true );
			this.canvasCtx.stroke();
			this.canvasCtx.fill();
			this.canvasCtx.save();
			this.canvasCtx.shadowOffsetX = -1;
			this.canvasCtx.shadowOffsetY = -1;
			this.canvasCtx.shadowBlur    = 1;
			this.canvasCtx.shadowColor   = this.getConfig('wheelTextShadowColor');
			this.canvasCtx.fillStyle     = this.getConfig('wheelTextColor');
			this.canvasCtx.translate(250 + Math.cos(angle + arc/2)*textRadius, 250 + Math.sin(angle + arc/2)*textRadius );
			this.canvasCtx.rotate(angle + arc/2 + Math.PI/2);
			this.canvasCtx.fillText(text, -this.canvasCtx.measureText(text).width/2, 0 );
			this.canvasCtx.restore();
			this.canvasCtx.closePath();
		} // end for

		this.drawArrow();

	}; // end SpinWheel::drawWheel()

	SpinWheel.prototype.easeOut = function(t,b,c,d) {
		var ts = (t/=d)*t;
		var tc = ts*t;
		return b+c*(tc + -3*ts + 3*t);
	}; // end SpinWheel::easeOut()

	// export the class onto the JavaScript object tree
	window.SpinWheel = SpinWheel;

})(jQuery);

(function($) {

	// spinwheel() jQuery plugin loader
	$.fn.spinwheel = function(config) {

		var $canvas = this; // the "this" object is the jQuery object that wraps the canvas HTML DOM object

		// create a new SpinWheel instance and store it on the canvas DOM object, which is attached to the DOM tree, so it will be accessible by external code
		var spinWheel = new SpinWheel($canvas, config );
		$canvas[0].spinWheel = spinWheel;

		// initialize it
		spinWheel.init();

	}; // end $.fn.spinwheel()

})(jQuery);

$(document).ready(function() {
	$('.canvas').spinwheel({'segmentTexts':['♈','♉','♊','♋','♌','♍','♎','♏','♐','♑','♒','♓']});
});

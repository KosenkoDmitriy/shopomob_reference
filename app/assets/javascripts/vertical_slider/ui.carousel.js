/*
 * jQuery UI Labs - Carousel
 * - for experimental use only -
 *
 * Copyright (c) 2009 AUTHORS.txt (http://ui.jquery.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * Depends:
 *  ui.core.js
 *	effects.core.js
 */
(function($){

$.widget("ui.carousel", {
	
	_init: function() {

		var self = this;
//        this.options.height
		//Prepare animation parameters and needed variables
		this.items = $(this.options.items, this.element).css({ position: "absolute", top: 0, left: 0, zIndex: 1 });
        console.log( "this.items.items= " +this.element.attr('id') + this.items.height() )
        console.log( "this.options.items= " +this.element.attr('id') + this.options.height )
		$.extend(this, {
			props: this.options.orientation == 'vertical' ? ['height', 'Height', 'top', 'Top'] : ['width', 'Width', 'left', 'Left'],
			start: Math.PI/2,
			speed: 0.03, //We need a default spead so the initialization works
			direction: 'left', //This is a live property, toggled during interaction
			step: 2*Math.PI/this.items.length,
			paddingX: this.element.outerWidth() / 2,
			paddingY: this.element.outerHeight() / 2,
			itemHeight: this.options.height || this.items.height(),
			itemWidth: this.options.width || this.items.width(),
			offset: this.element.offset()
		});
		
		//Add pause/resume functionality when you hover a item
		if(this.options.pausable) {
			this.items
				.bind('mouseenter.carousel', function() { self.pause(); })
				.bind('mouseout.carousel', function() { self.resume(); });
		}

		//Little trick to jump to the start position
		this.rotate("left"); this.rotate("right");
		
		//Auto animation for the carousel
		if(this.options.animate)
			self._startAnimation();

		$(this.options.handle || this.element)
			.bind('mouseenter.carousel', function() {
				self.offset = self.element.offset();
			})
			.bind('mouseleave.carousel', function() {
				self.options.animate ? self._startAnimation() : self.interval && clearInterval(self.interval);
			})
			.bind("mousemove.carousel", function(e) {

				if(self.paused || !self.options.animateByMouse) return;
				var mod = ((e[self.options.orientation == 'vertical' ? 'pageY' : 'pageX']-self.offset[self.props[2]]) - this['offset'+self.props[1]]/2);
				
				self.speed = Math.abs(mod)/5000;
				self.direction = mod < 0 ? "right" : "left";

		});

	},

	_setData: function(key, value) {
		$.widget.prototype._setData.apply(this, arguments);
		if(key == 'height') this.itemHeight = value;
		if(key == 'width') this.itemWidth = value;
	},

	destroy: function() {

		clearInterval(this.interval);
		this.element.unbind('.carousel');
		
		var self = this;
		window.setTimeout(function() {
			self.items.css({ left: '', top: '', position: '', height: '', width: '' }).unbind('.carousel');
			self.element.removeData('carousel');
		}, 0);

	},
	
	_startAnimation: function() {

		var self = this;
		this.speed = self.options.animate;

		this.interval && clearInterval(this.interval);
		this.interval = window.setInterval(function() { self.rotate(); }, 13);

	},
	
	resume: function() {
		this.paused = false;
		this.options.animate && this._startAnimation();
		this._trigger('resume');
	},
	
	pause: function() {

		var self = this;
		this.paused = true;

		this.options.pauseSpeed ? (this.speed = self.options.pauseSpeed) : (this.interval && clearInterval(this.interval));
		this._trigger('pause');

	},
	
	select: function(item) {
		
		this.currentItem = !isNaN(parseInt(item,10)) ? parseInt(item,10) : this.items.index(item);
		
		this.start = Math.PI/2;
		this.rotate('left', this.step * item);
		
		this._trigger('select', null, {
			value: item,
			item: this.items[item] 
		});
		
	},
	
	rotate: function(direction, speed) {

		var o = this.options, self = this;

		direction = direction || this.direction;
		this.speed = speed !== undefined ? speed : this.speed;
		this.start = this.start + (direction == "right" ? -this.speed : this.speed);
			
		self.items.each(function(i) {

			//var x = Math.min(0, self.options.radius * Math.cos(angle)); w00t! this makes a half carousel
			var angle = self.start + i * self.step,
				x = self.options.radius * Math.cos(angle),
				y = self.options.tilt * Math.sin(angle),
				width = Math.max(self.itemWidth - (o.distance * self.itemWidth), self.itemWidth * ((self.options.tilt+y) / (2 * self.options.tilt))),
				height = parseInt(width * self.itemHeight / self.itemWidth,10);

			$.extend(this.style, {
				top: self.paddingY + (self.options.orientation == 'vertical' ? x : y) - height/2 + "px",
				left: self.paddingX + (self.options.orientation == 'vertical' ? y : x) - width/2 + "px",
				width: width + "px",
				height: height + "px",
				zIndex: parseInt(100 * (self.options.tilt+y) / (2 * self.options.tilt),10)
			});
			
		});

	}
	
});

$.extend($.ui.carousel, {
	defaults: {
		animate: 0.005, //TODO: Setting animate to false also currently blocks animateByMouse
		animateByMouse: true,
		distance: 0.7,
		handle: false,
		items: '> *',
		orientation: 'horizontal',
		pausable: true,
		pauseSpeed: 0.001, //If you don't want to actually stop the carousel when hovering items, set it to something small, i.e. 0.001
		radius: 200,
		tilt: -0.1
	}
});
	
})(jQuery);
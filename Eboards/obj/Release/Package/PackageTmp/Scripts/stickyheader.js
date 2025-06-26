/*! jQuery Sticky Table Headers 1.0 */
/*  https://github.com/svivian/jquery-sticky-header */

(function ($) {
	$.fn.stickyheader = function () {
		return this.each(function () {

			var $table = $(this);
			// apply to tables only
			if ($table.prop('tagName').toUpperCase() !== 'TABLE')
				return;

			var tblPos = $table.offset();
			var tblSize = { width: $table.width(), height: $table.height() };
			// set each TH to its own width
			$table.find('> thead > tr > th').each(function () {
				var $th = $(this);
				var brWidth = parseInt($th.css('border-right-width').replace('px', ''), 10);
				var thWidth = $th.width(); // adding `brWidth` sometimes works
				$th.css({ width: thWidth });
			});

			// clone entire table and remove tbody (performance seems fine)
			var $newTable = $table.clone(true, true).removeAttr('id');
			$newTable.children('tbody').remove();

			var tblCSS = {
				position: 'fixed',
				top: 0,
				left: tblPos.left,
				width: tblSize.width,
				visibility: 'hidden'
			};
			$newTable.css(tblCSS).appendTo('body');

			$(window).scroll(function () {
				// while over the table, show sticky header
				var currTop = $(this).scrollTop();
				var scrollLimit = tblPos.top + tblSize.height - $newTable.height();
				if (currTop > tblPos.top && currTop < scrollLimit)
					$newTable.css({ visibility: 'visible' });
				else
					$newTable.css({ visibility: 'hidden' });
			});

		});
	};


	//$('table').stickyheader();

})(jQuery);

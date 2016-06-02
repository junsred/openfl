package openfl._internal.renderer.cairo;


import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.text.TextField;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class CairoShape {
	
	
	public static function render (shape:DisplayObject, renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render (graphics, renderSession, shape.__worldTransform);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__cairo != null && graphics.__visible /*&& graphics.__commands.length > 0*/ && bounds != null && graphics.__width >= 1 && graphics.__height >= 1) {
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
				var cairo = renderSession.cairo;
				var scrollRect = shape.scrollRect;
				
				if (renderSession.roundPixels) {
					
					var matrix = graphics.__worldTransform.__toMatrix3 ();
					matrix.tx = Math.round (matrix.tx);
					matrix.ty = Math.round (matrix.ty);
					cairo.matrix = matrix;
					
				} else {
					
					cairo.matrix = graphics.__worldTransform.__toMatrix3 ();
					
				}
				
				cairo.setSourceSurface (graphics.__cairo.target, 0, 0);
				
				if (scrollRect != null) {
					
					cairo.pushGroup ();
					cairo.newPath ();
					cairo.rectangle (scrollRect.x - bounds.x, scrollRect.y - bounds.y, scrollRect.width, scrollRect.height);
					cairo.fill ();
					cairo.popGroupToSource ();
					
				}
				
				cairo.paintWithAlpha (shape.__worldAlpha);
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}
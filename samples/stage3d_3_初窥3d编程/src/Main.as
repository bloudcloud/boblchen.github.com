package {

	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;

	public class Main extends Sprite {

		private var context3D 			: Context3D;
		private var shaderProgram 		: Program3D;
		private var vertexBuffer 		: VertexBuffer3D;
		private var indexBuffer 		: IndexBuffer3D;
		private var meshVertexData 		: Vector.<Number>;
		private var meshIndexData 		: Vector.<uint>;
		private var projectionMatrix 	: PerspectiveMatrix3D = new PerspectiveMatrix3D();
		private var modelMatrix 		: Matrix3D = new Matrix3D();
		private var viewMatrix 			: Matrix3D = new Matrix3D();
		private var modelViewProjection : Matrix3D = new Matrix3D();

		public function Main() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
		}

		private function onContext3DCreate(e : Event) : void {
			
			this.context3D = stage.stage3Ds[0].context3D;
			this.context3D.enableErrorChecking = true;

			meshVertexData = Vector.<Number>([
				//X,  Y,  Z,	
				-1, -1,  0, 	// 左下角
				 1, -1,  0, 	// 右下角
				 1,  1,  0, 	// 右上角
				-1,  1,  0,		// 左上角
			]);
			
			meshIndexData = Vector.<uint>([0, 1, 2, 0, 2, 3,]);

			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, "mov op, va0\n");

			var fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, "mov oc, fc0\n");
			
			shaderProgram = context3D.createProgram();
			shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);

			indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
			indexBuffer.uploadFromVector(meshIndexData, 0, meshIndexData.length);

			vertexBuffer = context3D.createVertexBuffer(meshVertexData.length / 3, 3);
			vertexBuffer.uploadFromVector(meshVertexData, 0, meshVertexData.length / 3);
			
			context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0, true);

			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(event : Event) : void {
			context3D.clear(0.2, 0.2, 0.2, 1);
			context3D.setProgram(shaderProgram);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1.0, 0, 0, 1]));
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.drawTriangles(indexBuffer, 0, meshIndexData.length / 3);
			context3D.present();
		}
		
	}
}

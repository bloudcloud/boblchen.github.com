package {

	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Main extends Sprite {
		public function Main() {
			var origin : Vector3D 	  = new Vector3D(1, 2, 3);
			var matrix : Matrix3D = new Matrix3D();
			matrix.appendTranslation(-10, -23, -43);
			matrix.appendRotation(344, Vector3D.X_AXIS);
			matrix.appendRotation(34,  Vector3D.Y_AXIS);
			matrix.appendRotation(123, Vector3D.Z_AXIS);
			var ret : Vector3D = matrix.transformVector(origin);
			trace("1x4向量矩阵", origin, "乘以4x4矩阵结果:", ret);		
			trace("计算4x4逆矩阵");
			matrix.invert();
			trace("结果向量矩阵", ret, "乘以4x4逆矩阵:", matrix.transformVector(ret));
		}
	}
}

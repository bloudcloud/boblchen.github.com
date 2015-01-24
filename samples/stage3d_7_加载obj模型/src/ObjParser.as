package {
	
	/**
	 * OBJ模型简易解析器 
	 * @author Neil
	 * 
	 */	
	public class ObjParser {
		
		/** 顶点数据 */
		public var vertices : Vector.<Number>;
		/** 法线数据 */
		public var normals  : Vector.<Number>;
		/** uv数据 */
		public var uvs		: Vector.<Number>; 
		/** 索引数据 */
		public var indices  : Vector.<uint>;
		
		// obj文本数据
		private var data : String = "";
		
		private var _vertIndices : Vector.<uint>;
		private var _normIndices : Vector.<uint>;
		private var _uvIndices	 : Vector.<uint>;
		private var _vertices	 : Vector.<Number>;
		private var _normals     : Vector.<Number>;
		private var _uvs		 : Vector.<Number>;
		
		private var _charIndex : uint = 0;
		private var _oldIndex  : uint = 0;
		private var _strLength : uint = 0;
		
		public function ObjParser() {
			
		}
		
		public function parse(txt : String) : void {
			this.data = txt;
			this.data = this.data.replace(/\\[\r\n]+\s*/gm, ' ');
			
			this.vertices = new Vector.<Number>();
			this.normals  = new Vector.<Number>();
			this.uvs      = new Vector.<Number>();
			this.indices  = new Vector.<uint>();
			
			this._vertIndices = new Vector.<uint>();
			this._normIndices = new Vector.<uint>();
			this._uvIndices   = new Vector.<uint>();
			
			this._vertices = new Vector.<Number>();
			this._normals  = new Vector.<Number>();
			this._uvs	   = new Vector.<Number>();
			
			var creturn : String = String.fromCharCode(10);
			
			if (this.data.indexOf(creturn) == -1) {
				creturn = String.fromCharCode(13);
			}
			
			this._strLength = this.data.length;
			this._charIndex = this.data.indexOf(creturn, 0);
			this._oldIndex	= 0;
			
			while (this._charIndex < this._strLength) {
				this._charIndex = this.data.indexOf(creturn, this._oldIndex);
				if (this._charIndex == -1) {
					this._charIndex = this._strLength;
				}
				// 获取obj的每一行内容
				var line : String = this.data.substring(this._oldIndex, this._charIndex);
				line = line.split('\r').join("");
				line = line.replace("  ", " ");
				// 对每一行进行拆分
				var tokens : Array = line.split(" ");
				this.parseLine(tokens);
				this._oldIndex = this._charIndex + 1;
			}
			
			// 组装数据,因为在面信息中，顶点、UV、法线都有自己单独的索引。
			// 因此我们需要根据索引拼凑出一个完整三角形的所有数据
			// 这个时候三角形的索引数据就为1,2,3,4,5,6,7,8.....
			var length : int = this._vertIndices.length;
			for (var i:int = 0; i < length; i++) {
				var vIdx : int = this._vertIndices[i] - 1;
				this.vertices.push(this._vertices[vIdx * 3], this._vertices[vIdx * 3 + 1], this._vertices[vIdx * 3 + 2]);
				var nIdx : int = this._normIndices[i] - 1;
				this.normals.push(this._normals[nIdx * 3], this._normals[nIdx * 3 + 1], this._normals[nIdx * 3 + 2]);
				var uIdx : int = this._uvIndices[i] - 1;
				this.uvs.push(this._uvs[uIdx * 2], this._uvs[uIdx * 2 + 1]);
				this.indices.push(i);
			}
		}
		
		private function parseLine(trunk:Array):void {
			switch (trunk[0]) {
				case "mtllib":
					break;
				case "g":
					break;
				case "o":
					break;
				case "usemtl":
					break;
				// 顶点坐标
				case "v":
					parseVertex(trunk);
					break;
				// uv坐标
				case "vt":
					parseUV(trunk);
					break;
				// 法线数据
				case "vn":
					parseVertexNormal(trunk);
					break;
				// 面信息
				case "f":
					parseFace(trunk);
			}
		}
		
		private function parseFace(trunk:Array):void {
			var len:uint = trunk.length;
			for (var i:uint = 1; i < len; ++i) {
				if (trunk[i] == "")
					continue;
				var indices : Array = trunk[i].split("/");
				this._vertIndices.push(parseInt(indices[0]));
				this._uvIndices.push(parseInt(indices[1]));
				this._normIndices.push(parseInt(indices[2]));
			}
		}
				
		private function parseVertexNormal(trunk : Array) : void {
			this._normals.push(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3]));
		}
		
		private function parseUV(trunk : Array) : void {
			// u, 1-v
			this._uvs.push(parseFloat(trunk[1]), 1 - parseFloat(trunk[2]));
		}
		
		private function parseVertex(trunk : Array) : void {
			this._vertices.push(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3]));
		}
		
		
	}
}

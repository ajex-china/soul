package soul.utils
{
	/**
	 *数组算法 
	 * @author Administrator
	 * 
	 */	
	public class ArrayUtil
	{
		/**
		 * 随即数组算法
		 * 自身插入法(此法在数组较短时效率高，超过200效率就不如传统插入法了) 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function selfRandomArray(arr:Array):Array
		{
			var outputArr:Array = arr.slice();
			var i:int = outputArr.length;
			while (i)
			{
				outputArr.push(outputArr.splice(int(Math.random() * i--), 1)[0]);
			}
			return outputArr;
		}
		/**
		 *  随即数组算法
		 * 传统插入法 在数组较长（200以上）时效率比自身插入法高 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function normalRandomArray(arr:Array):Array
		{
			var cloneArr:Array = arr.slice();
			var outputArr:Array = [];
			var i:int = cloneArr.length;
			while (i)
			{
				outputArr.push(cloneArr.splice(int(Math.random() * i--), 1)[0]);
			}
			return outputArr;
		}
		/**
		 * 随即数组算法
		 * 选择插入法 
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function selectRandomArray(arr:Array):Array
		{
			var outputArr:Array = arr.slice();
			var i:int = outputArr.length;
			var temp:*;
			var indexA:int;
			var indexB:int;
			
			while (i)
			{
				indexA = i-1;
				indexB = Math.floor(Math.random() * i);
				i--;
				
				if (indexA == indexB) continue;
				temp = outputArr[indexA];
				outputArr[indexA] = outputArr[indexB];
				outputArr[indexB] = temp;
			}
			
			return outputArr;
		}
	}
}
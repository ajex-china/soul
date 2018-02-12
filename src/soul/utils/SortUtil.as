package soul.utils
{
	/**
	 *排序类 (以后添加 根据key 对object的排序 )
	 * @author
	 * 
	 */	
	public class SortUtil
	{
		public var sortArray:Array;
		public var sortParam:*;
		public function SortUtil()
		{
		}
		public function getBubbleSortArr():Array
		{  
			var result:Array = sortArray.concat();  
			var i:int = 1;  
			var j:int = 0;  
			var n:int = result.length;  
			for(i=1;i<n;i++) {  
				for(j=0;j<n-i;j++) {  
					 if(result[j] > result[j+1]) {  
						var temp:Number = result[j];  
						result[j] = result[j+1];  
						result[j+1] = temp;  
						}  
					}  
				 }  
			return result;  
		}  
		
		public function getInsertionSortArr():Array 
		{  
			var result:Array = sortArray.concat();  
			 var i:int = 1;  
			var n:int = result.length;  
			 for(i=1;i<n;i++) {  
				var temp:Number = result[i];  
				var j:int = i - 1;  
				 while((j>=0) && (result[j] > temp)) {  
					 result[j+1] = result[j];          
					j--;  
					}  
				result[j+1] = temp;  
				}  
			 return result;  
		}
		
		public function getQuickSortArr():Array 
		{  
			var result:Array = sortArray.concat();  
			var n:int = result.length;  
			quickSort(result,0,n-1);  
			return result;  
		}  
		          
		private function quickSort(arr:Array,low:int,high:int):void 
		{  
			var i:int;  
			var j:int;  
			var x:int;  
			if (low < high) { //这个条件用来结束递归   
				i = low;  
				j = high;  
				x = arr[i];  
				while (i < j) {  
					while (i < j && arr[j] > x) {  
						j--; //从右向左找第一个小于x的数   
						}  
					if (i < j) {  
						arr[i] = arr[j];  
						 i++;  
						}  
					while (i < j && arr[i] < x) {  
						 i++; //从左向右找第一个大于x的数   
						}  
					if (i < j) {  
						arr[j] = arr[i];  
						j--;  
						}  
					}  
				arr[i] = x;  
				quickSort(arr, low, i - 1);  
				quickSort(arr, i + 1, high);  
			}  
		}
		public function getSelectionSort():Array
		{  
			var result:Array = sortArray.concat();  
			var i:int = 0;  
			var j:int = 0;  
			var n:int = result.length;  
			for (i = 0; i < n - 1; i++) {  
				var min:int = i;  
				for (j = i+1; j < n; j++) {  
					if (result[j] < result[min]) {  
						min = j;  
						}  
					}  
				 /* swap data[i] and data[min] */  
				var temp:Number = result[i];  
				result[i] = result[min];  
				result[min] = temp;  
				}  
			return result;  
		}
		public function getCocktailSortArr():Array
		{  
			var result:Array = sortArray.concat();  
			var i:int = 0;  
			var n:int = result.length;  
			var top:int = n - 1;  
			var bottom:int = 0;  
			var swapped:Boolean = true;   
			while(swapped) { // if no elements have been swapped, then the list is sorted   
				swapped = false;   
				var temp:Number;  
				for(i = bottom; i < top;i++) {  
					if(result[i] > result[i + 1]) {  // test whether the two elements are in the correct order   
						temp = result[i];// let the two elements change places   
						result[i] = result[i + 1];  
						result[i + 1] = temp;  
						swapped = true;  
						}  
					}  
				 // decreases top the because the element with the largest value in the unsorted   
				// part of the list is now on the position top    
				top = top - 1;   
				for(i = top; i > bottom;i--) {  
					if(result[i] < result[i - 1]) {  
						temp = result[i];  
						result[i] = result[i - 1];  
						result[i - 1] = temp;  
						swapped = true;  
						}  
					}  
				// increases bottom because the element with the smallest value in the unsorted    
				// part of the list is now on the position bottom    
				bottom = bottom + 1;    
				}  
			return result;  
		}
		
	}
}
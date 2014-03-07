package com.utils
{
	import com.model.GameModel;
	import com.vo.LinkInfoVo;
	import com.vo.PointVo;
	
	import flash.utils.Dictionary;

	/**
	 * 
	 * @author GY
	 */	
	public class GameUtil
	{
		private static var searchStar:SearchStar;
		private static var searchCache:Dictionary = new Dictionary(true);//存放所有已经寻路的寻路点
		/**
		 * 获取对应始末点位置的寻路路径
		 * @param startRow 起始行列
		 * @param startCol
		 * @param endRow 终止行列
		 * @param endCol
		 * @param area 所属区域
		 * @return 
		 */		
		public static function search(startRow:int,startCol:int,
						endRow:int,endCol:int,area:int,mode:int = 1):Vector.<PointVo>{
			if(searchStar == null)searchStar = new SearchStar();
			if(searchCache[startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area] !== undefined){
				var result:Vector.<PointVo> = searchCache[startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area];
				return result;
			}
			searchStar.setMapList(GameModel.getMapList(area),GameModel.mapRows,
				GameModel.mapCols,area,SearchStar.DIRECT_EIGHT,mode);
			result = searchStar.search(startCol,startRow,endCol,endRow);
			searchCache[startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area] = result;
			return result;
		}
		/**
		 * 获取两点之间距离
		 */		
		public static function getDistance(x1:Number, y1:Number, 
										   x2:Number, y2:Number):Number
		{
			return Math.sqrt(Math.pow(x1-x2,2) + Math.pow(y1-y2,2));
		}
		
		/**
		 * 获取两个视图之间坐标形成的夹角
		 * @return 
		 */		
		public static function getAngle(x1:Number, y1:Number, 
										x2:Number, y2:Number):Number{
			var dirtX:Number = x2 - x1;
			var dirtY:Number = y2 - y1;
			var angle:Number = Math.atan2(dirtY,dirtX) * 180 / Math.PI + 90;
			return (360 + angle) % 360;
		}
		/**
		 * 从目标点到地标之间进行递归寻路
		 * @param startRow
		 * @param startCol
		 * @param area
		 * @param ep
		 * @return 
		 */		
		public static function searchRoad(startRow:int,startCol:int,area:int,ep:PointVo):Vector.<PointVo>{
			var searchLoad:Array = [];
			tryRoad(startRow,startCol,area,new Dictionary(true),ep,searchLoad,true);
			searchLoad.sortOn("length",Array.NUMERIC);
			return searchLoad[0];
		}
		/**
		 * @param startRow
		 * @param startCol
		 * @param area
		 * @param table
		 * @param ep
		 * @param minV 寻找到的最短路径点数据
		 * @return 
		 * 
		 */		
		private static function tryRoad(startRow:int,startCol:int,area:int,table:Dictionary,
										ep:PointVo,searchLoad:Array,isRoot:Boolean = false):Vector.<PointVo>
		{
			if(ep.area == area){
				var r:Vector.<PointVo> = search(startRow,startCol,ep.x,ep.z,area);
				if(r != null){
					r = r.slice();
					if(isRoot)searchLoad.push(r.reverse());
					return r;
				}
			}
			var linkList:Vector.<LinkInfoVo> = GameModel.getAreaLink(area);
			for each (var lvo:LinkInfoVo in linkList) 
			{//判断当前关节点是否已经回路 没有再判断关节点之间是否能联通
				if(table[lvo.id] === undefined){//该关节还未参与寻路
					var lPoint:PointVo = lvo.postion;
					r = search(startRow,startCol,lPoint.x,lPoint.z,area);
					if(r != null){//表示能连通
						table[lvo.id] = true;
						//获取对应关节查找下一个入口
						var avo:LinkInfoVo = GameModel.getAnotherLink(lvo);
						if(avo == null)continue;//还没设置好关节点
						lPoint = avo.postion;
						var result:Vector.<PointVo> = tryRoad(lPoint.x,lPoint.z,lPoint.area,table,ep,searchLoad);
						if(result != null){
							var rList:Vector.<PointVo> = r.concat(result);//已经寻找到出路 最终返回
							if(isRoot){//回到根位置
								searchLoad.push(rList.reverse());
							}else return rList; //不是根位置的继续寻找
//							if(minV == null || rList.length < minV.length)minV = rList;
						}
						delete table[lvo.id];//没有找到只能舍弃 继续寻找下一个
					}
				}
			}
			return null;
		}		
		
		
		
		
		
		
		
		
		
		
	}
}
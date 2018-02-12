package soul.utils
{
	public class BlogUtil
	{
		public static function getSinaBlogURL(url:String,title:String,pic:String=null,ralateUid:String="1865166970",language:String="zh_cn",searchPic:Object=false):String
		{
			var str:String = "http://service.weibo.com/share/share.php?" + "url=" + url;
			if(title)
			{
				//str += "&title=" + title + "[" + getTime() + "]";
				str += "&title=" + title;
			}
			if(pic)
			{
				str += "&pic=" + pic;
			}
			if(ralateUid)
			{
				str += "&ralateUid=" + ralateUid;
			}
			if(language)
			{
				str += "&language=" + language;
			}
			str += "&searchPic=" + searchPic;
			str += "&rnd=" + DateUtil.getDateString();
			return str;
		}
		public static function getTencentBlogURL(url:String,title:String,site:String,pic:String=null,appKey:String="801199283"):String
		{
			var str:String = "http://v.t.qq.com/share/share.php?" + "url=" + url;
			if(title)
			{
				//str += "&title=" + title + "[" + getTime() + "]";
				str += "&title=" + title;
			}
			if(pic)
			{
				str += "&pic=" + pic;
			}
			if(site)
			{
				str += "&site=" + site;
			}
			if(appKey)
			{
				str += "&appkey=" + appKey;
			}
			return str;
		}
	}
}
package backend.chart;

class SongMetaData
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String, songColor:String = "")
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

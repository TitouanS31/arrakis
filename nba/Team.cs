using System.Text.RegularExpressions;   
public struct Team
{
    private string Name;
    public string _name => Name;
    private int Wins;
    public int _wins => Wins;
    private int Losses{set; get;}
    private List<string> OpponentsRemaining;
    private List<int> NumberOfGamesRemaining;
    public List<int> _numberOfGamesRemaining => NumberOfGamesRemaining;
    private string Link;
    private readonly Task<string> Page; 


    public override string ToString(){
        string str = "";
        foreach(string team in OpponentsRemaining)
        {
            str += team + " ";
        }
        return Name + " | " + Wins + " wins | Games: " + str;
    }

    public Team(string name, string link){
        Name = name;
        Link = link;
        Page = GetTeamPage();
        Wins = TeamWins(Page.Result);
        Losses = TeamLosses(Page.Result);
        OpponentsRemaining = GamesRemaining(Page.Result, Wins + Losses);
        NumberOfGamesRemaining = [];
    }   

    public void NbOfGamesRemaining(Team team)
    {
        int ret = 0;
        foreach(string opponent in OpponentsRemaining)
        {
            if(opponent == team.Name)
            {
                ret++;
            }
        }
        NumberOfGamesRemaining.Add(ret);
    }

    public static List<string> GamesRemaining(string page, int gamesPlayed)
    {
        string pattern = @"<div class=\""team-link-section\"">(.*?)</div>"; 
        Regex rg = new(pattern);
        MatchCollection matchedTeams = rg.Matches(page);
        List<string> opponentsRemaining = [];
        for (int i = gamesPlayed; i < matchedTeams.Count; i++)
        {
            string opponent = matchedTeams[i].Value.Replace("<div class=\"team-link-section\">","").Replace("</div>","");
            opponentsRemaining.Add(opponent);  
        }
        return opponentsRemaining;
    }

    public static int TeamWins(string page)
    {
        string pattern = @">W<"; 
        Regex rg = new(pattern);
        MatchCollection WinsCollection = rg.Matches(page);
        return WinsCollection.Count;
    } 

    public static int TeamLosses(string page)
    {
        string pattern = @">L<"; 
        Regex rg = new(pattern);
        MatchCollection WinsCollection = rg.Matches(page);
        return WinsCollection.Count;
    }       

    public async readonly Task<string> GetTeamPage()
    {
        HttpClient client = new();
        string page = await client.GetStringAsync("https://www.tankathon.com"+Link);
        return page;
    } 
} 
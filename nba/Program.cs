
using System.Text.RegularExpressions;

class Program
{
    public static List<(string, string)> teamLinksNames = [];

    public async static Task FillTeamLinksNames()
    {
        HttpClient client = new();

        string page = await client.GetStringAsync("https://www.tankathon.com");

        string pattern1 = @"<td class=\""name\""><a href=\""/[^\""]*\"">";
        Regex rg1 = new(pattern1);
        MatchCollection matchedLinks = rg1.Matches(page);

        string pattern2 = @"<div class=\""desktop\"">[^<]*</div>";
        Regex rg2 = new(pattern2);
        MatchCollection matchedTeams = rg2.Matches(page);
        
        if(matchedLinks.Count == matchedTeams.Count)
        {
            for (int i = 0; i < matchedLinks.Count; i++)
            {
                string str1 = matchedLinks[i].Value;
                string link = str1[26..^2];

                string str2 = matchedTeams[i].Value;
                string name = str2[21..^6];

                teamLinksNames.Add((name,link));  
            }
        }
        else
        {
            Console.WriteLine("Regexp error.");
        }
    }   

    public static void CreateTextFile(List<Team> teams)
    {
        string date = DateTime.Now.ToString("dd_MM_yyyy");

        string filePath = Directory.GetCurrentDirectory() + "/statsNBA_" + date + ".txt";
        if(File.Exists(filePath))
        {
            File.Delete(filePath);
        }

        using (StreamWriter outputFile = new StreamWriter(filePath, true))
        {
            outputFile.WriteLine(teams.Count);
            foreach(Team team in teams)
            {
                outputFile.Write(team._name.Replace(' ','_') + " " + team._wins);
                foreach(int games in team._numberOfGamesRemaining)
                {
                    outputFile.Write(" " + games);
                }
                outputFile.WriteLine();
            }
        }

    }

    static async Task Main()
    {
        List<Team> teams = [];
        await FillTeamLinksNames();
        teamLinksNames.Sort();

        foreach((string,string) link in teamLinksNames)
        {
            Team team = new(link.Item1,link.Item2);
            teams.Add(team);
        }

        foreach(Team team1 in teams)
        {
            foreach(Team team2 in teams)
            {
                team1.NbOfGamesRemaining(team2);
            }
        }

        CreateTextFile(teams);
    }

}
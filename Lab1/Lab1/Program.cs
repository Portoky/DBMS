using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Lab1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string conStr = "Data Source=(localdb)\\MSSQLLocalDB;" + "Initial Catalog=Library;Integrated Security=true;";
            SqlConnection con = new SqlConnection(conStr);

            con.Open();

            string strBooks = "Select * from Books";
            SqlCommand cmd = new SqlCommand(strBooks, con);

            //using(SqlDataReader reader = cmd.ExecuteReader())
            //{
            //    while (reader.Read())
            //    {
            //        Console.WriteLine("{0}, {1}, {2}, {3}", reader[0], reader[1], reader[2], reader[3]);    
            //    }
            //}


            SqlDataAdapter daLibrary = new SqlDataAdapter(strBooks, con);
            DataSet dataset = new DataSet();
            daLibrary.Fill(dataset, "InMemoryBooks");
            foreach(DataRow row in dataset.Tables["InMemoryBooks"].Rows)
            {
                Console.WriteLine("{0}, {1}, {2}, {3}", row["BookId"], row["SerialNumber"], row["Title"], row["Author"]);
            }

            con.Close();
        }
    }
}

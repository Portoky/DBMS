using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lab01
{
    public partial class Form1 : Form
    {

        SqlConnection con;
        SqlDataAdapter daBooks;
        SqlDataAdapter daCategory;
        DataSet dset;
        BindingSource bsBooks;
        BindingSource bsCategory;

        SqlCommandBuilder cmdBuilder;

        string queryBooks;
        string queryCategory;
        public Form1()
        {
            InitializeComponent();
            FillData();
        }

        void FillData()
        {
            this.con = new SqlConnection(getConnectionString());
            queryBooks = "Select * from Books";
            queryCategory = "Select * from Category";

            daBooks = new SqlDataAdapter(queryBooks, con);
            daCategory = new SqlDataAdapter(queryCategory, con);

            dset = new DataSet();
            daBooks.Fill(dset, "Books");
            daCategory.Fill(dset, "Category");

            cmdBuilder = new SqlCommandBuilder(daBooks);
           
            dset.Relations.Add("CategoryBooks",
                dset.Tables["Category"].Columns["CategoryId"],
                dset.Tables["Books"].Columns["CategoryId"]);

            //method 1
            //this.dataGridViewCategory.DataSource = dset.Tables["Category"];
            //this.dataGridViewBooks.DataSource = this.dataGridViewCategory.DataSource;
            //this.dataGridViewCategory.DataMember = "CategoryBooks";

            //method 2
            bsCategory = new BindingSource();
            bsCategory.DataSource = dset.Tables["Category"];
            bsBooks = new BindingSource(bsCategory, "CategoryBooks");    

            this.dataGridViewCategory.DataSource = bsCategory; 
            this.dataGridViewBooks.DataSource = bsBooks;

            cmdBuilder.GetUpdateCommand();

        }
        string getConnectionString()
        {
            return "Data Source=(localdb)\\MSSQLLocalDB;" + "Initial Catalog=Library;Integrated Security=true;";
        }
        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            daBooks.Update(dset, "Books");
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}

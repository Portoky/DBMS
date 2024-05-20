using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace PracticModel
{
    public partial class Form1 : Form
    {
        SqlConnection sqlConnection;
        DataSet ds;
        SqlDataAdapter daUsers, daPosts;
        SqlCommandBuilder sqlCommandBuilder;
        BindingSource bsUsers, bsPosts;

        
        public Form1()
        {
            InitializeComponent();

        }

        
        private void Form1_Load(object sender, EventArgs e)
        {
            sqlConnection = new SqlConnection("Data Source=(localdb)\\MSSQLLocalDB;" + "Initial Catalog=ModelPractic;Integrated Security=true;");
            ds = new DataSet();
            daUsers = new SqlDataAdapter("Select * From Users", sqlConnection);
            daPosts = new SqlDataAdapter("Select * From Posts", sqlConnection);
            sqlCommandBuilder = new SqlCommandBuilder(daPosts);

            daUsers.Fill(ds, "Users");
            daPosts.Fill(ds, "Posts");

            DataRelation dr = new DataRelation("FK_Posts_Users", ds.Tables["Users"].Columns["UserId"], ds.Tables["Posts"].Columns["UserId"]);

            ds.Relations.Add(dr);

            bsUsers = new BindingSource();
            bsUsers.DataSource = ds;
            bsUsers.DataMember = "Users";

            bsPosts = new BindingSource();
            bsPosts.DataSource = bsUsers;
            bsPosts.DataMember = "FK_Posts_Users";

            this.dgvUsers.DataSource = bsUsers;
            this.dgvPosts.DataSource = bsPosts;

        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            daPosts.Update(ds, "Posts");
        }

    }
}

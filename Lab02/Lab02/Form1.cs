using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lab02
{
    public partial class Form1 : Form
    {

        SqlConnection con;
        SqlDataAdapter daChild;
        SqlDataAdapter daParent;
        DataSet dset;
        BindingSource bsChild;
        BindingSource bsParent;

        SqlCommandBuilder cmdBuilder;

        string queryChild;
        string queryParent;
        public Form1()
        {
            try
            {
                InitializeComponent();
                fillData();
            }
            catch (Exception exc)
            {
                Console.WriteLine(exc.Message);
            }
        }

        void fillData()
        {
            this.con = new SqlConnection(getConnectionString());

            queryChild = ConfigurationManager.AppSettings["ChildQuery"];
            queryParent = ConfigurationManager.AppSettings["ParentQuery"];

            if(queryChild == null || queryParent == null)
            {
                throw new Exception("No query in config file!");
            }

            daChild = new SqlDataAdapter(queryChild, con);
            daParent = new SqlDataAdapter(queryParent, con);

            string childTableName = ConfigurationManager.AppSettings["ChildTableName"];
            string parentTableName = ConfigurationManager.AppSettings["ParentTableName"];

            if(childTableName == null || parentTableName == null)
            {
                throw new Exception("No tablename in config file!");
            }

            dset = new DataSet();
            daChild.Fill(dset, childTableName);
            daParent.Fill(dset, parentTableName);

            cmdBuilder = new SqlCommandBuilder(daChild);

            string relationship = ConfigurationManager.AppSettings["ParentChilRelationship"];
            string foreignkey = ConfigurationManager.AppSettings["ForeignKey"];

            if(relationship == null)
            {
                throw new Exception("No relationship given in config file!");
            }
            if (foreignkey == null)
            {
                throw new Exception("No foreignkey given in config file!");
            }

            dset.Relations.Add(relationship,
                dset.Tables[parentTableName].Columns[foreignkey],
                dset.Tables[childTableName].Columns[foreignkey]);

            bsParent = new BindingSource();
            bsParent.DataSource = dset.Tables[parentTableName];
            bsChild = new BindingSource(bsParent, relationship);

            this.parentDataGridView.DataSource = bsParent;
            this.childDataGridView.DataSource = bsChild;

            this.parentTextBox.Text = parentTableName;
            this.childTextBox.Text = childTableName;


            cmdBuilder.GetUpdateCommand();
        }

        string getConnectionString()
        {
            return "Data Source=(localdb)\\MSSQLLocalDB;" + "Initial Catalog=Library;Integrated Security=true;";
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(dset, ConfigurationManager.AppSettings["ChildTableName"]);
            }
            catch (Exception exc)
            {
                Console.WriteLine(exc.Message);
            }
        }
    }
}

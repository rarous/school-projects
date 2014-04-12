<%@ WebService Language="C#" Class="CvutSemestralniPrace.Adresar" %>

using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Collections;
using System.Configuration;

namespace CvutSemestralniPrace
{
	public class Kontakt
	{
		public int id;
		public string jmeno;
		public string prijmeni;
		public string email;
		public string www;
		public int telefon;
		public int icq;
	}

	[WebService(
		Namespace = "urn:CvutSemestralniPrace",
		Name = "AdresarKontaktu",
		Description = "XML web service for realization semestral work from X36Alg"
	)]
	public class Adresar : WebService
	{
		[WebMethod(
			Description = "Add new address into database"
		)]
		public void ulozKontakt(Kontakt kontakt)
		{
			SqlConnection objConn = new SqlConnection(ConfigurationSettings.AppSettings["ConnString"]);
			SqlCommand objCmd = new SqlCommand("sp_UlozKontakt", objConn);
			SqlParameter objParam = new SqlParameter();

			objCmd.CommandType = CommandType.StoredProcedure;
			objParam = objCmd.Parameters.Add("@Jmeno", SqlDbType.NVarChar, 50);
			objParam.Value = kontakt.jmeno;
			objParam = objCmd.Parameters.Add("@Prijmeni", SqlDbType.NVarChar, 50);
			objParam.Value = kontakt.prijmeni;
			objParam = objCmd.Parameters.Add("@Email", SqlDbType.NVarChar, 50);
			objParam.Value = kontakt.email;
			objParam = objCmd.Parameters.Add("@Www", SqlDbType.NVarChar, 50);
			objParam.Value = kontakt.www;
			objParam = objCmd.Parameters.Add("@Telefon", SqlDbType.Int, 4);
			objParam.Value = kontakt.telefon;
			objParam = objCmd.Parameters.Add("@Icq", SqlDbType.Int, 4);
			objParam.Value = kontakt.icq;

			objConn.Open();
				objCmd.ExecuteNonQuery();
			objConn.Close();
		}

		[WebMethod(
			Description = "Read address from database - lastname search"
		)]
		public Kontakt nactiKontakt(string prijmeni)
		{
			Kontakt kontakt = new Kontakt();
			SqlConnection objConn = new SqlConnection(ConfigurationSettings.AppSettings["ConnString"]);
			SqlCommand objCmd = new SqlCommand("sp_NajdiKontakt", objConn);
			SqlParameter objParam = new SqlParameter();

			objCmd.CommandType = CommandType.StoredProcedure;
			objParam = objCmd.Parameters.Add("@Prijmeni", SqlDbType.NVarChar, 50);
			objParam.Value = "%" + prijmeni + "%"; // pripojeny % pro dotaz LIKE

			objConn.Open();
				SqlDataReader objReader = objCmd.ExecuteReader();
					if(objReader.HasRows)
					{
						while(objReader.Read())
						{
							kontakt.id = objReader.GetInt32(0);
							kontakt.jmeno = objReader.GetString(1);
							kontakt.prijmeni = objReader.GetString(2);
							kontakt.email = objReader.GetString(3);
							kontakt.www = objReader.GetString(4);
							kontakt.telefon = objReader.GetInt32(5);
							kontakt.icq = objReader.GetInt32(6);
						}
					}
				objReader.Close();
			objConn.Close();
			return kontakt;
		}

		[WebMethod(
			Description = "Return all contacts from database"
		)]
		public Kontakt[] nactiKontakty()
		{
			SqlConnection objConn = new SqlConnection(ConfigurationSettings.AppSettings["ConnString"]);
			SqlDataAdapter objCmd = new SqlDataAdapter("SELECT * FROM tblAdresar", objConn);
			DataSet ds = new DataSet();
			objConn.Open();
				objCmd.Fill(ds, "Adresar");
			objConn.Close();
			
			Kontakt[] kontakt = new Kontakt[ds.Tables["Adresar"].Rows.Count];
			Kontakt adresa;
			
			for(int i = 0; i < kontakt.Length; i++)
			{
				adresa = new Kontakt();
				adresa.id = (int)ds.Tables["Adresar"].Rows[i]["id"];
				adresa.jmeno = ds.Tables["Adresar"].Rows[i]["jmeno"].ToString();
				adresa.prijmeni = ds.Tables["Adresar"].Rows[i]["prijmeni"].ToString();
				adresa.email = ds.Tables["Adresar"].Rows[i]["email"].ToString();
				adresa.www = ds.Tables["Adresar"].Rows[i]["www"].ToString();
				adresa.telefon = (int)ds.Tables["Adresar"].Rows[i]["telefon"];
				adresa.icq = (int)ds.Tables["Adresar"].Rows[i]["icq"];	
				kontakt[i] = adresa;
			}
			return kontakt;
		}
		
		[WebMethod(
			Description = "Delete address from database"
		)]
		public void smazKontakt(int id)
		{
			SqlConnection objConn = new SqlConnection(ConfigurationSettings.AppSettings["ConnString"]);
			SqlCommand objCmd = new SqlCommand("sp_SmazKontakt", objConn);
			SqlParameter objParam = new SqlParameter();

			objCmd.CommandType = CommandType.StoredProcedure;
			objParam = objCmd.Parameters.Add("@Id", SqlDbType.Int, 4);
			objParam.Value = id;
			
			objConn.Open();
				objCmd.ExecuteNonQuery();
			objConn.Close();
		}
	}
}
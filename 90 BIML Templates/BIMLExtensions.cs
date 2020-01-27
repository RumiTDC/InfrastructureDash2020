using System.Collections.Generic;
using System.Linq;
using System.Text;
using Varigence.Biml.Extensions;
using System;
using System.Data;
using System.Data.SqlClient;

public static class BIMLExtensions
{
    public static DataTable GetDataTableFromSQL(string SQL, string ConnectionString)
    {
        DataTable dtMyTable = new DataTable();
        SqlDataAdapter daMyAdapter = new  SqlDataAdapter(SQL, ConnectionString);
        daMyAdapter.Fill(dtMyTable);

        return dtMyTable;
    }
    public static DataTable GetDataTableFromSQL2(string SQL, string ConnectionString)
    {
        DataTable dtMyTable = new DataTable();
        SqlDataAdapter daMyAdapter = new SqlDataAdapter(SQL, ConnectionString);
        daMyAdapter.Fill(dtMyTable);

        return dtMyTable;
    }

    public static string SQLSourceGetViewColumns()
    {
        return null;
    }
    public static string GetConnectionString(string ConnectionName, string UtilityConnectionString)
    {
        string ConnectionString = "";
        string sql =
              "SELECT ConnectionString FROM [BIML].[Connection] WHERE Name = @Name; ";
        using (SqlConnection conn = new SqlConnection(UtilityConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.Add("@Name", SqlDbType.VarChar);
            cmd.Parameters["@Name"].Value = ConnectionName;
            conn.Open();
            var result = cmd.ExecuteScalar();
            if(result != null)
            {
                ConnectionString = result.ToString();
            }
            //ConnectionString = cmd.ExecuteScalar();
        }
        return ConnectionString;
    }

    public static string GetMetaDataConnectionString(string ConnectionName, string UtilityConnectionString)
    {
        string ConnectionString = "";
        string sql =
              "SELECT ConnectionStringMetaData FROM [BIML].[Connection] WHERE Name = @Name; ";
        using (SqlConnection conn = new SqlConnection(UtilityConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.Add("@Name", SqlDbType.VarChar);
            cmd.Parameters["@Name"].Value = ConnectionName;
            conn.Open();
            var result = cmd.ExecuteScalar();
            if (result != null)
            {
                ConnectionString = result.ToString();
            }
            //ConnectionString = cmd.ExecuteScalar().ToString();
        }
        return ConnectionString;
    }

    public static DataTable GetColumnsForTableOrView(string Schema, string TableName, string ConnectionString, string ConnectionId)
    {
        // string SQL = string.Format("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '{0}' AND TABLE_NAME = '{1}' ORDER BY ORDINAL_POSITION", Schema, TableName);
        string SQL = string.Format(@"SELECT con.DataConversionType
                    , SourceColumnName AS COLUMN_NAME
                    , datatype.StageDataType AS DATA_TYPE, SourceIsNullable AS IS_NULLABLE, SourceCharacterMaximumLength AS CHARACTER_MAXIMUM_LENGTH
                    , SourceNumericPrecision AS NUMERIC_PRECISION, SourceNumericScale AS NUMERIC_SCALE, SourceDatetime AS DATETIME_PRECISION
					, ConditionalDataType
					, ConditionalOutput 
                    FROM[BIML].[StageColumn] as col INNER JOIN[BIML].[StageTable] as tab ON col.StageTableId = tab.Id 
                    INNER JOIN[BIML].[Connection] as con ON tab.ConnectionId = con.Id 
                    INNER JOIN[BIML].[DataTypeConversions] as datatype ON datatype.ConversionType = con.DataConversionType AND datatype.SourceDataType = col.SourceDataType 
                    WHERE IncludeDataType = 1 AND col.Enabled = 1 AND tab.SourceSchema = '{0}' AND tab.SourceTableName = '{1}'  AND tab.ConnectionId = '{2}' 
                    ORDER BY SourceOrdinalPosition", Schema, TableName, ConnectionId);

        return GetDataTableFromSQL(SQL, ConnectionString);
    }
    public static DataTable GetCharColumnsForTableOrView(string Schema, string TableName, string ConnectionString, string ConnectionId)
    {
        string SQL = string.Format(@"SELECT SourceColumnName AS COLUMN_NAME, datatype.StageDataType AS DATA_TYPE, SourceIsNullable AS IS_NULLABLE
                    , SourceCharacterMaximumLength AS CHARACTER_MAXIMUM_LENGTH, SourceNumericPrecision AS NUMERIC_PRECISION, SourceNumericScale AS NUMERIC_SCALE
                    , SourceDatetime AS DATETIME_PRECISION FROM[BIML].[StageColumn] as col 
                    INNER JOIN[BIML].[StageTable] as tab ON col.StageTableId = tab.Id 
                    INNER JOIN[BIML].[Connection] as con ON tab.ConnectionId = con.Id 
                    INNER JOIN[BIML].[DataTypeConversions] as datatype ON datatype.ConversionType = con.DataConversionType AND datatype.SourceDataType = col.SourceDataType 
                    WHERE tab.SourceSchema = '{0}' AND tab.SourceTableName = '{1}'   AND tab.ConnectionId = '{2}'  AND datatype.StageDataType LIKE '%char%' AND col.Enabled = 1
                    ORDER BY SourceOrdinalPosition", Schema, TableName, ConnectionId);

        return GetDataTableFromSQL(SQL, ConnectionString);
    }
    public static DataTable GetPrimaryKeysForTable(string Schema, string TableName, string ConnectionString, string ConnectionId)
    {
        string SQL = string.Format(@"SELECT ConstraintName =  tab.SourceSchema + '|' + tab.SourceTableName + '|' + cast(tab.ConnectionId AS varchar(30))
                                        , ColumnName = SourceColumnName 
                    FROM[BIML].[StageColumn] as col INNER JOIN[BIML].[StageTable] as tab ON col.StageTableId = tab.Id 
                    INNER JOIN[BIML].[Connection] as con ON tab.ConnectionId = con.Id 
                    INNER JOIN[BIML].[DataTypeConversions] as datatype ON datatype.ConversionType = con.DataConversionType AND datatype.SourceDataType = col.SourceDataType 
                    WHERE IncludeDataType = 1 AND tab.SourceSchema = '{0}' AND tab.SourceTableName = '{1}'  AND tab.ConnectionId = '{2}'
                    AND SourcePrimaryKey = 'pk' AND col.Enabled = 1 
                    ORDER BY SourceOrdinalPosition", Schema, TableName, ConnectionId);

        return GetDataTableFromSQL(SQL, ConnectionString);

    }

    public static DataTable GetColumnsForTableOrViewEDW(string Schema, string TableName, string ConnectionString)
    {
        string SQL = string.Format("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '{0}' AND TABLE_NAME = '{1}' ORDER BY ORDINAL_POSITION", Schema, TableName);

        return GetDataTableFromSQL(SQL, ConnectionString);
    }
    public static DataTable GetCharColumnsForTableOrViewEDW(string Schema, string TableName, string ConnectionString)
    {
        string SQL = string.Format("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '{0}' AND TABLE_NAME = '{1}' AND DATA_TYPE LIKE '%char%' ORDER BY ORDINAL_POSITION", Schema, TableName);

        return GetDataTableFromSQL(SQL, ConnectionString);
    }
    public static DataTable GetPrimaryKeysForTableEDW(string Schema, string TableName, string ConnectionString)
    {
        string SQL = string.Format(@"SELECT
                                        ConstraintName = T.CONSTRAINT_NAME
                                        , ColumnName = C.COLUMN_NAME
                                        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS As T
                                        INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE As C ON T.CONSTRAINT_NAME = C.CONSTRAINT_NAME AND C.CONSTRAINT_SCHEMA = T.CONSTRAINT_SCHEMA AND T.TABLE_NAME = C.TABLE_NAME AND T.TABLE_SCHEMA = C.TABLE_SCHEMA
                                        WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
                                        AND T.TABLE_SCHEMA = '{0}'
                                        AND T.TABLE_NAME = '{1}'", Schema, TableName);

        return GetDataTableFromSQL(SQL, ConnectionString);

    }


    public static DataTable GetDimensionKeys(string UtilityConnectionString)
    {
        string SQL = string.Format(@"exec BIML.GetDimensionsKeys;");

        return GetDataTableFromSQL(SQL, UtilityConnectionString);

    }
    public static bool SearchDataTableForValue(DataTable table, string ColumnNameToSearch, string SearchString)
    {
        bool result = false;

        foreach(DataRow row in table.Rows)
        {
            if (row[ColumnNameToSearch].ToString() == SearchString)
            {
                result = true;
            }
        }

        return result;
    }
    public static string SearchDataTableForValue(DataTable table, string ColumnNameToSearch, string SearchString, string ColumnToReturn)
    {
        string result = null;

        foreach (DataRow row in table.Rows)
        {
            if (row[ColumnNameToSearch].ToString() == SearchString)
            {
                result = row[ColumnToReturn].ToString();
            }
        }

        return result;
    }
    public static string GetEDWTableCreateScript(DataRow tableRow, string ConnectionString, string UtilityConnectionString, string DestinationTableNamePostFix = "")
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceViewNameUnsafe"].ToString().Trim();
        string DestinationSchema = tableRow["DestinationSchema"].ToString().Trim();
        string DestinationTableName = "[" + tableRow["DestinationTableNameUnsafe"].ToString().Trim() + DestinationTableNamePostFix + "]";
        string BusinessKeyColumnName = tableRow["BusinessKeyColumnName"].ToString().Trim();
        string SurrogatKeyColumnName = tableRow["SurrogatKeyColumnName"].ToString().Trim();
        string TableType = tableRow["TableType"].ToString().Trim();
        string EDWDateCreatedColumnName = tableRow["EDWDateCreatedColumnName"].ToString().Trim();
        DataTable DimensionKeys = GetDimensionKeys(UtilityConnectionString);
        string RoleplayingDimensionSourceBusinessKeyColumnName = tableRow["RoleplayingDimensionSourceBusinessKeyColumnName"].ToString().Trim();
        string DimensionBusinessKeyColumnName = tableRow["DimensionBusinessKeyColumnName"].ToString().Trim();


        DataTable tableColumns = GetColumnsForTableOrViewEDW(Schema, TableName, ConnectionString);

        StringBuilder SQLCreateScript = new StringBuilder();

        SQLCreateScript.AppendLine("CREATE TABLE " + DestinationSchema + "." + DestinationTableName + "(");
        if(TableType == "Dimension")
        {
            SQLCreateScript.AppendLine(SurrogatKeyColumnName + " int PRIMARY KEY");
        }
        foreach(DataRow column in tableColumns.Rows)
        {
            if(tableColumns.Rows[0] != column || TableType == "Dimension")
            {
                SQLCreateScript.Append(",");
            }
            if(TableType == "Fact" && SearchDataTableForValue(DimensionKeys, "DimensionBusinessKeyColumnName", column["COLUMN_NAME"].ToString()))
            {
                SQLCreateScript.AppendLine("[" + SearchDataTableForValue(DimensionKeys, "DimensionBusinessKeyColumnName", column["COLUMN_NAME"].ToString(), "DimensionSurrogatKeyColumnName") + "] int");
            }
            else if(TableType == "Dimension" && column["COLUMN_NAME"].ToString() == RoleplayingDimensionSourceBusinessKeyColumnName)
            {
                SQLCreateScript.AppendLine("[" + DimensionBusinessKeyColumnName + "] " + GetEDWDataTypeFromSourceDataType(column));
            }
            else
            {
                SQLCreateScript.AppendLine("[" + column["COLUMN_NAME"].ToString() + "] " + GetEDWDataTypeFromSourceDataType(column));
            }
        }
        SQLCreateScript.AppendLine("," + EDWDateCreatedColumnName + " datetime2(7) default sysdatetime()");

        SQLCreateScript.AppendLine(")");

        return SQLCreateScript.ToString();
    }
    public static string GetStageSourceSelectScript(DataRow tableRow, string ConnectionString, string UtilityConnectionString, string ConnectionId)
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceTableNameUnsafe"].ToString().Trim();
        string SchemaSafe = tableRow["SourceSchema"].ToString().Trim();
        string TableNameSafe = tableRow["SourceTableName"].ToString().Trim();
        bool IsNavisionTable = bool.Parse(tableRow["NavisionTemplate"].ToString());
        string NavisionPrefix = tableRow["NavisionCompanyPrefix"].ToString().Trim();
        string SafeDelimiterStart = tableRow["SafeDelimiterStart"].ToString().Trim();
        string SafeDelimiterEnd = tableRow["SafeDelimiterEnd"].ToString().Trim();
        string DataConversionType = tableRow["DataConversionType"].ToString().Trim();

        DataTable DataTypeConversions = GetDataTypeConversions(UtilityConnectionString, tableRow["DataConversionType"].ToString());

        DataTable tableColumns = GetColumnsForTableOrView(Schema, TableName, ConnectionString, ConnectionId);

        StringBuilder SQLSelectScript = new StringBuilder();

        SQLSelectScript.AppendLine("SELECT ");

        foreach (DataRow column in tableColumns.Rows)
        {
            if (tableColumns.Rows[0] != column)
            {
                SQLSelectScript.Append(",");
            }


            //SQLSelectScript.AppendLine(SafeDelimiterStart + column["COLUMN_NAME"].ToString() + SafeDelimiterEnd + " ");

            //string ConditionalOutput = column["ConditionalOutput"].ToString().Trim();

            //if (ConditionalOutput.ToString().Length > 0)
            //{
            //    SQLSelectScript.AppendLine(" = " + ConditionalOutput.ToString());
            //}
                       

            string ConditionalOutput = column["ConditionalOutput"].ToString().Trim();

            if (ConditionalOutput.ToString().Length > 0)
            {
                SQLSelectScript.AppendLine(ConditionalOutput.ToString() + " as ");
            }

            SQLSelectScript.AppendLine(SafeDelimiterStart + column["COLUMN_NAME"].ToString() + SafeDelimiterEnd + " ");

        }

        SQLSelectScript.AppendLine("FROM " + SchemaSafe + "." + TableNameSafe);

        return SQLSelectScript.ToString();
    }

    public static string GetFactSourceSelectScript(DataRow tableRow, string ConnectionString, string UtilityConnectionString)
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceViewNameUnsafe"].ToString().Trim();
        string SchemaSafe = tableRow["SourceSchema"].ToString().Trim();
        string TableNameSafe = tableRow["SourceViewName"].ToString().Trim();

        DataTable tableColumns = GetColumnsForTableOrViewEDW(Schema, TableName, ConnectionString);

        StringBuilder SQLSelectScript = new StringBuilder();

        SQLSelectScript.AppendLine("SELECT ");

        foreach (DataRow column in tableColumns.Rows)
        {
            if (tableColumns.Rows[0] != column)
            {
                SQLSelectScript.Append(",");
            }
            SQLSelectScript.AppendLine("[" + column["COLUMN_NAME"].ToString() + "]");
        }

        SQLSelectScript.AppendLine("FROM " + SchemaSafe + "." + TableNameSafe);

        return SQLSelectScript.ToString();
    }
    public static string GetDimensionSourceSelectScript(DataRow tableRow, string ConnectionString, string UtilityConnectionString)
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceViewNameUnsafe"].ToString().Trim();
        string SchemaSafe = tableRow["SourceSchema"].ToString().Trim();
        string TableNameSafe = tableRow["SourceViewName"].ToString().Trim();
        string RoleplayingDimensionSourceBusinessKeyColumnName = tableRow["RoleplayingDimensionSourceBusinessKeyColumnName"].ToString().Trim();
        string DimensionBusinessKeyColumnName = tableRow["DimensionBusinessKeyColumnName"].ToString().Trim();
        string CustomSourceDimensionSurrogatKeyColumnName = tableRow["CustomSourceDimensionSurrogatKeyColumnName"].ToString().Trim();
        string SurrogatKeyColumnName = tableRow["SurrogatKeyColumnName"].ToString().Trim();

        DataTable tableColumns = GetColumnsForTableOrViewEDW(Schema, TableName, ConnectionString);

        StringBuilder SQLSelectScript = new StringBuilder();

        SQLSelectScript.AppendLine("SELECT ");

        foreach (DataRow column in tableColumns.Rows)
        {
            if (tableColumns.Rows[0] != column)
            {
                SQLSelectScript.Append(",");
            }
            if(column["COLUMN_NAME"].ToString() == RoleplayingDimensionSourceBusinessKeyColumnName)
            {
                SQLSelectScript.AppendLine(DimensionBusinessKeyColumnName + " = [" + column["COLUMN_NAME"].ToString() + "]");
            }
            else
            {
                SQLSelectScript.AppendLine("[" + column["COLUMN_NAME"].ToString() + "]");
            }
        }
        if (!string.IsNullOrEmpty(CustomSourceDimensionSurrogatKeyColumnName))
        {
            SQLSelectScript.AppendLine("," + SurrogatKeyColumnName + " = [" + CustomSourceDimensionSurrogatKeyColumnName + "]");
        }

        SQLSelectScript.AppendLine("FROM " + SchemaSafe + "." + TableNameSafe);

        return SQLSelectScript.ToString();
    }
    public static string GetStageSourceSelectScriptNavision(DataRow tableRow, string ConnectionString, string UtilityConnectionString, string ConnectionId)
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceTableNameUnsafe"].ToString().Trim();
        string SchemaSafe = tableRow["SourceSchema"].ToString().Trim();
        string TableNameSafe = tableRow["SourceTableName"].ToString().Trim();
        bool IsNavisionTable = bool.Parse(tableRow["NavisionTemplate"].ToString());
        string NavisionPrefix = tableRow["NavisionCompanyPrefix"].ToString().Trim();

        string SafeDelimiterStart = tableRow["SafeDelimiterStart"].ToString().Trim();
        string SafeDelimiterEnd = tableRow["SafeDelimiterEnd"].ToString().Trim();

        // irellevant with new metadata table: DataTable tableColumns = GetColumnsForTableOrView(Schema, NavisionPrefix + "$" + TableName, ConnectionString);
        DataTable tableColumns = GetColumnsForTableOrView(Schema, TableName, ConnectionString, ConnectionId);

        StringBuilder SQLSelectScript = new StringBuilder();

        SQLSelectScript.AppendLine("SELECT ");

        foreach (DataRow column in tableColumns.Rows)
        {
            if (tableColumns.Rows[0] != column)
            {
                SQLSelectScript.Append(",");
            }

            string ConditionalOutput = column["ConditionalOutput"].ToString().Trim();

            if (ConditionalOutput.ToString().Length > 0) // Need to check for conditional overwiritng first
            {               
                SQLSelectScript.AppendLine(SafeDelimiterStart + column["COLUMN_NAME"].ToString() + SafeDelimiterEnd);
                SQLSelectScript.AppendLine(" = " + ConditionalOutput.ToString());
            }
            else
            {

                //Need to special-convert timestamp columns
                if (String.Equals(column["COLUMN_NAME"].ToString(), (string)"timestamp", StringComparison.OrdinalIgnoreCase))
                {
                    SQLSelectScript.AppendLine("CAST(" + SafeDelimiterStart + column["COLUMN_NAME"].ToString() + SafeDelimiterEnd + " AS bigint) AS " + column["COLUMN_NAME"].ToString());
                    //SQLSelectScript.AppendLine("[" + column["COLUMN_NAME"].ToString() + "]");
                }
                else
                {
                    SQLSelectScript.AppendLine(SafeDelimiterStart + column["COLUMN_NAME"].ToString() + SafeDelimiterEnd);
                }
            }     
        }

        SQLSelectScript.AppendLine(@"FROM " + SchemaSafe + "." + SafeDelimiterStart + "\" + @[User::NavSqlPrefix] + \"$" + TableName + SafeDelimiterEnd);

        return "\"" + SQLSelectScript.ToString() + "\"";
    }
    public static string GetStageTableCreateScript(DataRow tableRow, string ConnectionString, string UtilityConnectionString, string ConnectionId, string DestinationTableNamePostFix = "")
    {
        string Schema = tableRow["SourceSchemaUnsafe"].ToString().Trim();
        string TableName = tableRow["SourceTableNameUnsafe"].ToString().Trim();
        string DestinationSchema = tableRow["DestinationSchema"].ToString().Trim();
        string DestinationTableName = "[" + tableRow["DestinationTableNameUnsafe"].ToString().Trim() + DestinationTableNamePostFix + "]";
        bool IsNavisionTable = bool.Parse(tableRow["NavisionTemplate"].ToString());
        string NavisionPrefix = tableRow["NavisionCompanyPrefix"].ToString().Trim();
        string StageDateCreatedColumnName = tableRow["StageDateCreatedColumnName"].ToString().Trim();
        bool IncludePrimaryKeys = bool.Parse(tableRow["IncludePrimaryKey"].ToString());
        string DataConversionType = tableRow["DataConversionType"].ToString().Trim();
      

        // Temp replace. Must be dealt with if works.
        ConnectionString = UtilityConnectionString;

        if (IsNavisionTable)
        {
          // Irellevant with new metadatatable  TableName = NavisionPrefix + "$" + TableName;
        }

       

        //DataTable DataTypeConversions = GetDataTypeConversions(UtilityConnectionString, tableRow["SourceConnectionName"]);
        DataTable DataTypeConversions = GetDataTypeConversions(UtilityConnectionString, tableRow["DataConversionType"].ToString());

        DataTable tableColumns = GetColumnsForTableOrView(Schema, TableName, ConnectionString, ConnectionId);

        StringBuilder SQLCreateScript = new StringBuilder();

        SQLCreateScript.AppendLine("CREATE TABLE " + DestinationSchema + "." + DestinationTableName + "(");

        foreach(DataRow column in tableColumns.Rows)
        {
            if(tableColumns.Rows[0] != column)
            {
                SQLCreateScript.Append(",");
            }
            string ConditionalDataType = column["ConditionalDataType"].ToString().Trim();
            string ConditionalOutput = column["ConditionalOutput"].ToString().Trim();
            string DestinationDataType = ConditionalDataType.ToString().Length > 0 ? ConditionalDataType : GetStageDataTypeFromSourceDataType(column, DataTypeConversions);
            SQLCreateScript.AppendLine("[" + column["COLUMN_NAME"].ToString() + "] " + DestinationDataType);
        }
        if(IsNavisionTable)
        {
            SQLCreateScript.AppendLine(",CompanyID int");
        }
        SQLCreateScript.AppendLine("," + StageDateCreatedColumnName + " datetime2(7) default sysdatetime()");
        if(IncludePrimaryKeys)
        {
            StringBuilder sqlPrimaryKeys = new StringBuilder();
            DataTable PrimaryKeys = BIMLExtensions.GetPrimaryKeysForTable(Schema, TableName, ConnectionString, ConnectionId);
            
            if(PrimaryKeys.Rows.Count > 0)
            {
                sqlPrimaryKeys.Append(",CONSTRAINT [" + PrimaryKeys.Rows[0]["ConstraintName"].ToString().Trim() + DestinationTableNamePostFix + "_" + tableRow["DestinationTableNameUnsafe"].ToString().Trim() + "] PRIMARY KEY (");
                foreach(DataRow primaryKey in PrimaryKeys.Rows)
                {
                    if (PrimaryKeys.Rows[0] != primaryKey)
                    {
                        sqlPrimaryKeys.AppendLine(", ");
                    }
                    sqlPrimaryKeys.Append("[" + primaryKey["ColumnName"].ToString() + "]");
                }
                if(IsNavisionTable)
                {
                    sqlPrimaryKeys.Append(",[CompanyID]");
                }
                sqlPrimaryKeys.Append(")");
                SQLCreateScript.AppendLine(sqlPrimaryKeys.ToString());
            }
        }

        SQLCreateScript.AppendLine(")");



        return SQLCreateScript.ToString();
                
        //return "test";
    }
    public static string GetDataType(DataTable DataTypeTable, DataRow columnInfo, string DataTypeType)
    {
        string DATA_TYPE = columnInfo["DATA_TYPE"].ToString();
        string CHARACTER_MAXIMUM_LENGTH = columnInfo["CHARACTER_MAXIMUM_LENGTH"].ToString();
        if (CHARACTER_MAXIMUM_LENGTH == "-1")
        {
            DATA_TYPE = DATA_TYPE + "(max)";
        }

        string OutputDataType = null;


        foreach (DataRow row in DataTypeTable.Rows)
        {          
            if (row["StageDataType"].ToString().ToLower().Trim() == DATA_TYPE.ToLower().Trim())
            {              
               OutputDataType = row[DataTypeType].ToString();
            }
        }
        return OutputDataType;
    }
    public static DataTable GetDataTypeConversions(string UtilityConnectionString, string ConversionType)
    {
       // if (ConversionType != "oracle")
       // { ConversionType == "Default"; }
        string SQL = string.Format(@"SELECT * FROM [BIML].[DataTypeConversions]  WHERE ConversionType = '{0}'",ConversionType);

        return GetDataTableFromSQL(SQL, UtilityConnectionString);
    }
    public static bool TableExist(string ConnectionString, string Schema, string TableName)
    {
        bool resultOutput = true;

        string sql =
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName";
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.Add("@Schema", SqlDbType.VarChar);
            cmd.Parameters["@Schema"].Value = Schema;
            cmd.Parameters.Add("@TableName", SqlDbType.VarChar);
            cmd.Parameters["@TableName"].Value = TableName;
            conn.Open();
            var result = cmd.ExecuteScalar();
            if ((int)result == 0 )
            {
                resultOutput = false;
            }
        }
        return resultOutput;
    }
    public static void ExecuteSQL(string SQL, string ConnectionString)
    {
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(SQL, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    public static void ValidateOrCreateStageSchema(string Schema, string ConnectionString)
    {
        int SchemaExists = 0;
        string sql =
              "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = @Schema; ";
        using (SqlConnection conn = new SqlConnection(ConnectionString))
        {
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.Add("@Schema", SqlDbType.VarChar);
            cmd.Parameters["@Schema"].Value = Schema;
            conn.Open();
            var result = cmd.ExecuteScalar();
            if (result != null)
            {
                SchemaExists = (int)result;
            }
            if (SchemaExists == 0)
            {
                string SchemaCreateSQL = "CREATE SCHEMA " + Schema + ";";
                ExecuteSQL(SchemaCreateSQL, ConnectionString);
            }
            //ConnectionString = cmd.ExecuteScalar();
        }
    }
    public static string GetStageDataTypeFromSourceDataType(DataRow sourceRow, DataTable DataTypeTable)
    {
        string DATA_TYPE = sourceRow["DATA_TYPE"].ToString();
        string IS_NULLABLE = sourceRow["IS_NULLABLE"].ToString();
        string CHARACTER_MAXIMUM_LENGTH = sourceRow["CHARACTER_MAXIMUM_LENGTH"].ToString();
       // string CHARACTER_OCTET_LENGTH = sourceRow["CHARACTER_OCTET_LENGTH"].ToString();
        string NUMERIC_PRECISION = sourceRow["NUMERIC_PRECISION"].ToString();
     //   string NUMERIC_PRECISION_RADIX = sourceRow["NUMERIC_PRECISION_RADIX"].ToString();
        string NUMERIC_SCALE = sourceRow["NUMERIC_SCALE"].ToString();
        string DATETIME_PRECISION = sourceRow["DATETIME_PRECISION"].ToString();

        string OutputDataType = null;
        string DataTypeSpecification = "";


        foreach (DataRow row in DataTypeTable.Rows)
        {
            if (row["SourceDataType"].ToString() == DATA_TYPE)
            {
                OutputDataType = row["StageDataType"].ToString();
            }
        }

        if (OutputDataType == null)
        {
            OutputDataType = DATA_TYPE;
        }

        if (CHARACTER_MAXIMUM_LENGTH == null || CHARACTER_MAXIMUM_LENGTH == "")
        {
            CHARACTER_MAXIMUM_LENGTH = "-1";
        }

        switch (OutputDataType.ToLower().Trim())
        {
            case "varchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "nvarchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "nchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "char":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "binary":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "varbinary":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "decimal":
                DataTypeSpecification = "(" + NUMERIC_PRECISION + "," + NUMERIC_SCALE + ")";
                break;
            case "numeric":
                OutputDataType = NUMERIC_PRECISION == null ? "float" : OutputDataType;  // This line and the one below are pure Oracle workaround on mapping NUMBER with empty scale and precision to float.
                DataTypeSpecification = NUMERIC_PRECISION == null ? "" : "(" + NUMERIC_PRECISION + "," + NUMERIC_SCALE + ")";
                break;
            case "datetime2":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
            case "datetimeoffset":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
            case "time":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
        }

        return OutputDataType + DataTypeSpecification;
    }
    public static string GetEDWDataTypeFromSourceDataType(DataRow sourceRow)
    {
        string DATA_TYPE = sourceRow["DATA_TYPE"].ToString();
        string IS_NULLABLE = sourceRow["IS_NULLABLE"].ToString();
        string CHARACTER_MAXIMUM_LENGTH = sourceRow["CHARACTER_MAXIMUM_LENGTH"].ToString();
        string CHARACTER_OCTET_LENGTH = sourceRow["CHARACTER_OCTET_LENGTH"].ToString();
        string NUMERIC_PRECISION = sourceRow["NUMERIC_PRECISION"].ToString();
        string NUMERIC_PRECISION_RADIX = sourceRow["NUMERIC_PRECISION_RADIX"].ToString();
        string NUMERIC_SCALE = sourceRow["NUMERIC_SCALE"].ToString();
        string DATETIME_PRECISION = sourceRow["DATETIME_PRECISION"].ToString();

        string OutputDataType = null;
        string DataTypeSpecification = "";


        OutputDataType = DATA_TYPE;

        switch(OutputDataType.ToLower().Trim())
        {
            case "varchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "nvarchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "nchar":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "char":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "binary":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "varbinary":
                DataTypeSpecification = CHARACTER_MAXIMUM_LENGTH == "-1" ? "(MAX)" : "(" + CHARACTER_MAXIMUM_LENGTH + ")";
                break;
            case "decimal":
                DataTypeSpecification = "(" + NUMERIC_PRECISION + "," + NUMERIC_SCALE + ")";
                break;
            case "numeric":
                DataTypeSpecification = "(" + NUMERIC_PRECISION + "," + NUMERIC_SCALE + ")";
                break;
            case "datetime2":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
            case "datetimeoffset":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
            case "time":
                DataTypeSpecification = "(" + DATETIME_PRECISION + ")";
                break;
        }

        return OutputDataType + DataTypeSpecification;
    }
}
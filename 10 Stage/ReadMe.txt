Project content
------------------------------------
Base ETL framework for BI development

© 2013 Inspari A/S - www.inspari.dk


Requirements
------------------------------------
Microsoft SQL Server 2012 or higher
   - Database engine
   - Integration Services
   - SQL Agent


Install guide
------------------------------------
1. Create SSIS Catalog as described in the documentation
2. Run scripts (numeric order)
3. Create SSIS projects for, remember that you need to have the execution_MasterExecution package for each project:
   - SSIS EDW Stage
   - SSIS EDW Dimension
   - SSIS EDW Fact
4. Copy relevant SSIS template packages to each project


Prepare for production guide
------------------------------------
1. Deploy SSIS packages to SSISDB
   - Create folder (default: BusinessIntelligence)
2. Run "setup_GetSSISPackageFromSSISDB.dtsx"
3. Add job(s) to setup.PackageJob
4. Add job configuration to setup.PackageJobExecution
5. Create SQL Agent job and job step
   - Set SSIS package to MasterExecution.dtsx at SSISDB
   - Set job step configuration:
      - Code: \Package.Variables[JobName].Value
      - Value: replace with job name


Change log
------------------------------------
Date		Init	Description
2013-10-28	BB		Initial design and build of project, from Inspari Framework (1.08)
CREATE TABLE [dbo].[BBR_Daekning_tbl] (
    [Kvhx]                             VARCHAR (17)   NULL,
    [kvhx_aws]                         VARCHAR (19)   NULL,
    [bbrid_kvhx]                       VARCHAR (40)   NULL,
    [BbrKode]                          FLOAT (53)     NULL,
    [Kvh]                              VARCHAR (11)   NULL,
    [bbrid_kvh]                        VARCHAR (40)   NULL,
    [Postnummer]                       FLOAT (53)     NULL,
    [Kommunekode]                      FLOAT (53)     NULL,
    [Vejkode]                          FLOAT (53)     NULL,
    [Vejnavn]                          VARCHAR (40)   NULL,
    [vejnavn20]                        VARCHAR (20)   NULL,
    [Husnummertal]                     FLOAT (53)     NULL,
    [Husnummerbogstav]                 VARCHAR (1)    NULL,
    [Etage]                            VARCHAR (2)    NULL,
    [Sidedoer]                         VARCHAR (4)    NULL,
    [Lokalitet]                        VARCHAR (34)   NULL,
    [Stednavn]                         VARCHAR (34)   NULL,
    [Latitude]                         FLOAT (53)     NULL,
    [Longitude]                        FLOAT (53)     NULL,
    [X_EUREF89]                        FLOAT (53)     NULL,
    [Y_EUREF89]                        FLOAT (53)     NULL,
    [X_ED50]                           FLOAT (53)     NULL,
    [Y_ED50]                           FLOAT (53)     NULL,
    [dok_ctr]                          VARCHAR (4)    NULL,
    [dok_ctr_node]                     VARCHAR (12)   NULL,
    [ctr_x]                            FLOAT (53)     NULL,
    [ctr_y]                            FLOAT (53)     NULL,
    [dok_koblingsvej]                  VARCHAR (600)  NULL,
    [antal_kbl_pr_kvha]                FLOAT (53)     NULL,
    [trio_kunde_pr_kvha]               FLOAT (53)     NULL,
    [duo_bb_kunde_pr_kvha]             FLOAT (53)     NULL,
    [raa_kobber_kunde_pr_kvha]         FLOAT (53)     NULL,
    [afs_kvha_ctr]                     INT            NULL,
    [afs_kvha_ctr_db]                  NUMERIC (7, 2) NULL,
    [ctr_alcatel]                      FLOAT (53)     NULL,
    [ctr_ericson_mm]                   FLOAT (53)     NULL,
    [ctr_siemens3]                     FLOAT (53)     NULL,
    [ctr_adsl]                         FLOAT (53)     NULL,
    [ctr_vector]                       VARCHAR (20)   NULL,
    [ctr_vdsl_ds]                      INT            NULL,
    [ctr_vdsl_us]                      INT            NULL,
    [ctr_adsl_downprio_ds]             INT            NULL,
    [ctr_adsl_downprio_us]             INT            NULL,
    [ctr_adsl_upprio_ds]               INT            NULL,
    [ctr_adsl_upprio_us]               INT            NULL,
    [ctr_downprio_ds]                  INT            NULL,
    [ctr_downprio_us]                  INT            NULL,
    [ctr_upprio_ds]                    INT            NULL,
    [ctr_upprio_us]                    INT            NULL,
    [ctr_shdsl]                        FLOAT (53)     NULL,
    [ctr_ghdsl]                        FLOAT (53)     NULL,
    [antal_ekstra_kobber_pr_kvha]      INT            NULL,
    [fdslam_ctr]                       VARCHAR (10)   NULL,
    [fdslam_node]                      VARCHAR (20)   NULL,
    [fdslam_x]                         FLOAT (53)     NULL,
    [fdslam_y]                         FLOAT (53)     NULL,
    [antal_fdslam_kbl_pr_kvha]         FLOAT (53)     NULL,
    [afs_kvha_fdslam]                  INT            NULL,
    [afs_kvha_fdslam_db]               NUMERIC (7, 2) NULL,
    [fdslam_alcatel]                   FLOAT (53)     NULL,
    [fdslam_ericson_mm]                FLOAT (53)     NULL,
    [fdslam_siemens3]                  FLOAT (53)     NULL,
    [fdslam_adsl]                      FLOAT (53)     NULL,
    [fdslam_vector]                    VARCHAR (20)   NULL,
    [fdslam_node_shaping]              VARCHAR (3)    NULL,
    [fdslam_vdsl_ds]                   INT            NULL,
    [fdslam_vdsl_us]                   INT            NULL,
    [fdslam_adsl_downprio_ds]          INT            NULL,
    [fdslam_adsl_downprio_us]          INT            NULL,
    [fdslam_adsl_upprio_ds]            INT            NULL,
    [fdslam_adsl_upprio_us]            INT            NULL,
    [fdslam_downprio_ds]               INT            NULL,
    [fdslam_downprio_us]               INT            NULL,
    [fdslam_upprio_ds]                 INT            NULL,
    [fdslam_upprio_us]                 INT            NULL,
    [fdslam_shdsl]                     FLOAT (53)     NULL,
    [fdslam_ghdsl]                     FLOAT (53)     NULL,
    [mawis_ctr_node]                   VARCHAR (20)   NULL,
    [mawis_ctr_db150]                  FLOAT (53)     NULL,
    [antal_mawis_ctr_pr_kvha]          FLOAT (53)     NULL,
    [mawis_ctr_vdsl_ds]                FLOAT (53)     NULL,
    [mawis_ctr_vdsl_us]                FLOAT (53)     NULL,
    [mawis_ctr_adsl_downprio_ds]       FLOAT (53)     NULL,
    [mawis_ctr_adsl_downprio_us]       FLOAT (53)     NULL,
    [mawis_ctr_adsl_upprio_ds]         FLOAT (53)     NULL,
    [mawis_ctr_adsl_upprio_us]         FLOAT (53)     NULL,
    [mawis_ctr_downprio_ds]            FLOAT (53)     NULL,
    [mawis_ctr_downprio_us]            FLOAT (53)     NULL,
    [mawis_ctr_upprio_ds]              FLOAT (53)     NULL,
    [mawis_ctr_upprio_us]              FLOAT (53)     NULL,
    [pred_ctr_vdsl_ds]                 FLOAT (53)     NULL,
    [pred_ctr_vdsl_us]                 FLOAT (53)     NULL,
    [pred_ctr_adsl_downprio_ds]        FLOAT (53)     NULL,
    [pred_ctr_adsl_downprio_us]        FLOAT (53)     NULL,
    [pred_ctr_adsl_upprio_ds]          FLOAT (53)     NULL,
    [pred_ctr_adsl_upprio_us]          FLOAT (53)     NULL,
    [pred_ctr_downprio_ds]             FLOAT (53)     NULL,
    [pred_ctr_downprio_us]             FLOAT (53)     NULL,
    [pred_ctr_upprio_ds]               FLOAT (53)     NULL,
    [pred_ctr_upprio_us]               FLOAT (53)     NULL,
    [mawis_fdslam_node]                VARCHAR (20)   NULL,
    [mawis_fdslam_db150]               FLOAT (53)     NULL,
    [antal_mawis_fdslam_pr_kvha]       FLOAT (53)     NULL,
    [mawis_fdslam_vdsl_ds]             FLOAT (53)     NULL,
    [mawis_fdslam_vdsl_us]             FLOAT (53)     NULL,
    [mawis_fdslam_adsl_downprio_ds]    FLOAT (53)     NULL,
    [mawis_fdslam_adsl_downprio_us]    FLOAT (53)     NULL,
    [mawis_fdslam_adsl_upprio_ds]      FLOAT (53)     NULL,
    [mawis_fdslam_adsl_upprio_us]      FLOAT (53)     NULL,
    [mawis_fdslam_downprio_ds]         FLOAT (53)     NULL,
    [mawis_fdslam_downprio_us]         FLOAT (53)     NULL,
    [mawis_fdslam_upprio_ds]           FLOAT (53)     NULL,
    [mawis_fdslam_upprio_us]           FLOAT (53)     NULL,
    [pred_fdslam_vdsl_ds]              FLOAT (53)     NULL,
    [pred_fdslam_vdsl_us]              FLOAT (53)     NULL,
    [pred_fdslam_adsl_downprio_ds]     FLOAT (53)     NULL,
    [pred_fdslam_adsl_downprio_us]     FLOAT (53)     NULL,
    [pred_fdslam_adsl_upprio_ds]       FLOAT (53)     NULL,
    [pred_fdslam_adsl_upprio_us]       FLOAT (53)     NULL,
    [pred_fdslam_downprio_ds]          FLOAT (53)     NULL,
    [pred_fdslam_downprio_us]          FLOAT (53)     NULL,
    [pred_fdslam_upprio_ds]            FLOAT (53)     NULL,
    [pred_fdslam_upprio_us]            FLOAT (53)     NULL,
    [ctr_db150]                        NUMERIC (9, 2) NULL,
    [fdslam_db150]                     NUMERIC (9, 2) NULL,
    [kobber_downprio_ds]               INT            NULL,
    [kobber_downprio_us]               INT            NULL,
    [kobber_upprio_ds]                 INT            NULL,
    [kobber_upprio_us]                 INT            NULL,
    [antal_fiber_adr_pr_kvha]          FLOAT (53)     NULL,
    [antal_fiber_gravning_adr_pr_kvha] FLOAT (53)     NULL,
    [antal_fiber_stik_adr_pr_kvha]     FLOAT (53)     NULL,
    [antal_gpon_adr_pr_kvha]           FLOAT (53)     NULL,
    [antal_trefor_adr_pr_kvha]         FLOAT (53)     NULL,
    [coax_ejer]                        VARCHAR (6)    NULL,
    [coax_anlaeg_id]                   VARCHAR (10)   NULL,
    [antal_coax_tv_adr_pr_kvha]        FLOAT (53)     NULL,
    [antal_coax_bb_adr_pr_kvha]        FLOAT (53)     NULL,
    [antal_coax_chic_adr_pr_kvha]      FLOAT (53)     NULL,
    [antal_coax_docsis31_adr_pr_kvha]  FLOAT (53)     NULL,
    [antal_coax_stik_adr_pr_kvha]      FLOAT (53)     NULL,
    [coax_stik_kvhx_state]             INT            NULL,
    [coax_stik_kvhx_state_txt]         VARCHAR (255)  NULL,
    [antal_coax_andre_op_pr_kvha]      FLOAT (53)     NULL,
    [max_coax_ds]                      FLOAT (53)     NULL,
    [max_coax_us]                      FLOAT (53)     NULL,
    [x_mobil]                          FLOAT (53)     NULL,
    [y_mobil]                          FLOAT (53)     NULL,
    [mobil_indoor_3g]                  FLOAT (53)     NULL,
    [mobil_outdoor_3g]                 FLOAT (53)     NULL,
    [mobil_indoor_4g]                  FLOAT (53)     NULL,
    [mobil_outdoor_4g]                 FLOAT (53)     NULL,
    [mobil_indoor]                     FLOAT (53)     NULL,
    [mobil_outdoor]                    FLOAT (53)     NULL,
    [CTFL_CTR]                         VARCHAR (9)    NULL,
    [zone]                             VARCHAR (50)   NULL,
    [LogDatetime]                      DATETIME       CONSTRAINT [BBR_Daekning_LogDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidFromDatetime]                DATETIME       CONSTRAINT [BBR_Daekning_ValidFromDatetime_DF] DEFAULT (getdate()) NOT NULL,
    [ValidToDatetime]                  DATETIME       NULL,
    [IsCurrent]                        BIT            CONSTRAINT [BBR_Daekning_IsCurrent_DF] DEFAULT ((1)) NOT NULL,
    [IsDeleted]                        BIT            CONSTRAINT [BBR_Daekning_IsDeleted_DF] DEFAULT ((0)) NOT NULL,
    [DAWA_KVHX]                        VARCHAR (19)   NULL,
    [LastChangedDatetime]              DATETIME       CONSTRAINT [BBR_Daekning_tbl_LastChangedDatetime_DF] DEFAULT (getdate()) NOT NULL
);


GO
CREATE CLUSTERED INDEX [BBR_Daekning_tbl_ClusteredIndex]
    ON [dbo].[BBR_Daekning_tbl]([Kvhx] ASC, [IsCurrent] ASC, [IsDeleted] ASC) WITH (FILLFACTOR = 90);


GO



CREATE TRIGGER [dbo].[BBR_Daekning_tbl_AfterUpdateTrigger]
   ON  [dbo].[BBR_Daekning_tbl]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [dbo].[BBR_Daekning_tbl](
		[Kvhx]
		,[kvhx_aws]
		,[bbrid_kvhx]
		,[BbrKode]
		,[Kvh]
		,[bbrid_kvh]
		,[Postnummer]
		,[Kommunekode]
		,[Vejkode]
		,[Vejnavn]
		,[vejnavn20]
		,[Husnummertal]
		,[Husnummerbogstav]
		,[Etage]
		,[Sidedoer]
		,[Lokalitet]
		,[Stednavn]
		,[Latitude]
		,[Longitude]
		,[X_EUREF89]
		,[Y_EUREF89]
		,[X_ED50]
		,[Y_ED50]
		,[dok_ctr]
		,[dok_ctr_node]
		,[ctr_x]
		,[ctr_y]
		,[dok_koblingsvej]
		,[antal_kbl_pr_kvha]
		,[trio_kunde_pr_kvha]
		,[duo_bb_kunde_pr_kvha]
		,[raa_kobber_kunde_pr_kvha]
		,[afs_kvha_ctr]
		,[afs_kvha_ctr_db]
		,[ctr_alcatel]
		,[ctr_ericson_mm]
		,[ctr_siemens3]
		,[ctr_adsl]
		,[ctr_vector]
		,[ctr_vdsl_ds]
		,[ctr_vdsl_us]
		,[ctr_adsl_downprio_ds]
		,[ctr_adsl_downprio_us]
		,[ctr_adsl_upprio_ds]
		,[ctr_adsl_upprio_us]
		,[ctr_downprio_ds]
		,[ctr_downprio_us]
		,[ctr_upprio_ds]
		,[ctr_upprio_us]
		,[ctr_shdsl]
		,[ctr_ghdsl]
		,[antal_ekstra_kobber_pr_kvha]
		,[fdslam_ctr]
		,[fdslam_node]
		,[fdslam_x]
		,[fdslam_y]
		,[antal_fdslam_kbl_pr_kvha]
		,[afs_kvha_fdslam]
		,[afs_kvha_fdslam_db]
		,[fdslam_alcatel]
		,[fdslam_ericson_mm]
		,[fdslam_siemens3]
		,[fdslam_adsl]
		,[fdslam_vector]
		,[fdslam_node_shaping]
		,[fdslam_vdsl_ds]
		,[fdslam_vdsl_us]
		,[fdslam_adsl_downprio_ds]
		,[fdslam_adsl_downprio_us]
		,[fdslam_adsl_upprio_ds]
		,[fdslam_adsl_upprio_us]
		,[fdslam_downprio_ds]
		,[fdslam_downprio_us]
		,[fdslam_upprio_ds]
		,[fdslam_upprio_us]
		,[fdslam_shdsl]
		,[fdslam_ghdsl]
		,[mawis_ctr_node]
		,[mawis_ctr_db150]
		,[antal_mawis_ctr_pr_kvha]
		,[mawis_ctr_vdsl_ds]
		,[mawis_ctr_vdsl_us]
		,[mawis_ctr_adsl_downprio_ds]
		,[mawis_ctr_adsl_downprio_us]
		,[mawis_ctr_adsl_upprio_ds]
		,[mawis_ctr_adsl_upprio_us]
		,[mawis_ctr_downprio_ds]
		,[mawis_ctr_downprio_us]
		,[mawis_ctr_upprio_ds]
		,[mawis_ctr_upprio_us]
		,[pred_ctr_vdsl_ds]
		,[pred_ctr_vdsl_us]
		,[pred_ctr_adsl_downprio_ds]
		,[pred_ctr_adsl_downprio_us]
		,[pred_ctr_adsl_upprio_ds]
		,[pred_ctr_adsl_upprio_us]
		,[pred_ctr_downprio_ds]
		,[pred_ctr_downprio_us]
		,[pred_ctr_upprio_ds]
		,[pred_ctr_upprio_us]
		,[mawis_fdslam_node]
		,[mawis_fdslam_db150]
		,[antal_mawis_fdslam_pr_kvha]
		,[mawis_fdslam_vdsl_ds]
		,[mawis_fdslam_vdsl_us]
		,[mawis_fdslam_adsl_downprio_ds]
		,[mawis_fdslam_adsl_downprio_us]
		,[mawis_fdslam_adsl_upprio_ds]
		,[mawis_fdslam_adsl_upprio_us]
		,[mawis_fdslam_downprio_ds]
		,[mawis_fdslam_downprio_us]
		,[mawis_fdslam_upprio_ds]
		,[mawis_fdslam_upprio_us]
		,[pred_fdslam_vdsl_ds]
		,[pred_fdslam_vdsl_us]
		,[pred_fdslam_adsl_downprio_ds]
		,[pred_fdslam_adsl_downprio_us]
		,[pred_fdslam_adsl_upprio_ds]
		,[pred_fdslam_adsl_upprio_us]
		,[pred_fdslam_downprio_ds]
		,[pred_fdslam_downprio_us]
		,[pred_fdslam_upprio_ds]
		,[pred_fdslam_upprio_us]
		,[ctr_db150]
		,[fdslam_db150]
		,[kobber_downprio_ds]
		,[kobber_downprio_us]
		,[kobber_upprio_ds]
		,[kobber_upprio_us]
		,[antal_fiber_adr_pr_kvha]
		,[antal_fiber_gravning_adr_pr_kvha]
		,[antal_fiber_stik_adr_pr_kvha]
		,[antal_gpon_adr_pr_kvha]
		,[antal_trefor_adr_pr_kvha]
		,[coax_ejer]
		,[coax_anlaeg_id]
		,[antal_coax_tv_adr_pr_kvha]
		,[antal_coax_bb_adr_pr_kvha]
		,[antal_coax_chic_adr_pr_kvha]
		,[antal_coax_docsis31_adr_pr_kvha]
		,[antal_coax_stik_adr_pr_kvha]
		,[coax_stik_kvhx_state]
		,[coax_stik_kvhx_state_txt]
		,[antal_coax_andre_op_pr_kvha]
		,[max_coax_ds]
		,[max_coax_us]
		,[x_mobil]
		,[y_mobil]
		,[mobil_indoor_3g]
		,[mobil_outdoor_3g]
		,[mobil_indoor_4g]
		,[mobil_outdoor_4g]
		,[mobil_indoor]
		,[mobil_outdoor]
		,[CTFL_CTR]
		,[zone]
		,[LogDatetime]
		,[ValidFromDatetime]
		,[ValidToDatetime]
		,[IsCurrent]
		,[IsDeleted])
	SELECT 
		D.[Kvhx],
		D.[kvhx_aws],
		D.[bbrid_kvhx],
		D.[BbrKode],
		D.[Kvh],
		D.[bbrid_kvh],
		D.[Postnummer],
		D.[Kommunekode],
		D.[Vejkode],
		D.[Vejnavn],
		D.[vejnavn20],
		D.[Husnummertal],
		D.[Husnummerbogstav],
		D.[Etage],
		D.[Sidedoer],
		D.[Lokalitet],
		D.[Stednavn],
		D.[Latitude],
		D.[Longitude],
		D.[X_EUREF89],
		D.[Y_EUREF89],
		D.[X_ED50],
		D.[Y_ED50],
		D.[dok_ctr],
		D.[dok_ctr_node],
		D.[ctr_x],
		D.[ctr_y],
		D.[dok_koblingsvej],
		D.[antal_kbl_pr_kvha],
		D.[trio_kunde_pr_kvha],
		D.[duo_bb_kunde_pr_kvha],
		D.[raa_kobber_kunde_pr_kvha],
		D.[afs_kvha_ctr],
		D.[afs_kvha_ctr_db],
		D.[ctr_alcatel],
		D.[ctr_ericson_mm],
		D.[ctr_siemens3],
		D.[ctr_adsl],
		D.[ctr_vector],
		D.[ctr_vdsl_ds],
		D.[ctr_vdsl_us],
		D.[ctr_adsl_downprio_ds],
		D.[ctr_adsl_downprio_us],
		D.[ctr_adsl_upprio_ds],
		D.[ctr_adsl_upprio_us],
		D.[ctr_downprio_ds],
		D.[ctr_downprio_us],
		D.[ctr_upprio_ds],
		D.[ctr_upprio_us],
		D.[ctr_shdsl],
		D.[ctr_ghdsl],
		D.[antal_ekstra_kobber_pr_kvha],
		D.[fdslam_ctr],
		D.[fdslam_node],
		D.[fdslam_x],
		D.[fdslam_y],
		D.[antal_fdslam_kbl_pr_kvha],
		D.[afs_kvha_fdslam],
		D.[afs_kvha_fdslam_db],
		D.[fdslam_alcatel],
		D.[fdslam_ericson_mm],
		D.[fdslam_siemens3],
		D.[fdslam_adsl],
		D.[fdslam_vector],
		D.[fdslam_node_shaping],
		D.[fdslam_vdsl_ds],
		D.[fdslam_vdsl_us],
		D.[fdslam_adsl_downprio_ds],
		D.[fdslam_adsl_downprio_us],
		D.[fdslam_adsl_upprio_ds],
		D.[fdslam_adsl_upprio_us],
		D.[fdslam_downprio_ds],
		D.[fdslam_downprio_us],
		D.[fdslam_upprio_ds],
		D.[fdslam_upprio_us],
		D.[fdslam_shdsl],
		D.[fdslam_ghdsl],
		D.[mawis_ctr_node],
		D.[mawis_ctr_db150],
		D.[antal_mawis_ctr_pr_kvha],
		D.[mawis_ctr_vdsl_ds],
		D.[mawis_ctr_vdsl_us],
		D.[mawis_ctr_adsl_downprio_ds],
		D.[mawis_ctr_adsl_downprio_us],
		D.[mawis_ctr_adsl_upprio_ds],
		D.[mawis_ctr_adsl_upprio_us],
		D.[mawis_ctr_downprio_ds],
		D.[mawis_ctr_downprio_us],
		D.[mawis_ctr_upprio_ds],
		D.[mawis_ctr_upprio_us],
		D.[pred_ctr_vdsl_ds],
		D.[pred_ctr_vdsl_us],
		D.[pred_ctr_adsl_downprio_ds],
		D.[pred_ctr_adsl_downprio_us],
		D.[pred_ctr_adsl_upprio_ds],
		D.[pred_ctr_adsl_upprio_us],
		D.[pred_ctr_downprio_ds],
		D.[pred_ctr_downprio_us],
		D.[pred_ctr_upprio_ds],
		D.[pred_ctr_upprio_us],
		D.[mawis_fdslam_node],
		D.[mawis_fdslam_db150],
		D.[antal_mawis_fdslam_pr_kvha],
		D.[mawis_fdslam_vdsl_ds],
		D.[mawis_fdslam_vdsl_us],
		D.[mawis_fdslam_adsl_downprio_ds],
		D.[mawis_fdslam_adsl_downprio_us],
		D.[mawis_fdslam_adsl_upprio_ds],
		D.[mawis_fdslam_adsl_upprio_us],
		D.[mawis_fdslam_downprio_ds],
		D.[mawis_fdslam_downprio_us],
		D.[mawis_fdslam_upprio_ds],
		D.[mawis_fdslam_upprio_us],
		D.[pred_fdslam_vdsl_ds],
		D.[pred_fdslam_vdsl_us],
		D.[pred_fdslam_adsl_downprio_ds],
		D.[pred_fdslam_adsl_downprio_us],
		D.[pred_fdslam_adsl_upprio_ds],
		D.[pred_fdslam_adsl_upprio_us],
		D.[pred_fdslam_downprio_ds],
		D.[pred_fdslam_downprio_us],
		D.[pred_fdslam_upprio_ds],
		D.[pred_fdslam_upprio_us],
		D.[ctr_db150],
		D.[fdslam_db150],
		D.[kobber_downprio_ds],
		D.[kobber_downprio_us],
		D.[kobber_upprio_ds],
		D.[kobber_upprio_us],
		D.[antal_fiber_adr_pr_kvha],
		D.[antal_fiber_gravning_adr_pr_kvha],
		D.[antal_fiber_stik_adr_pr_kvha],
		D.[antal_gpon_adr_pr_kvha],
		D.[antal_trefor_adr_pr_kvha],
		D.[coax_ejer],
		D.[coax_anlaeg_id],
		D.[antal_coax_tv_adr_pr_kvha],
		D.[antal_coax_bb_adr_pr_kvha],
		D.[antal_coax_chic_adr_pr_kvha],
		D.[antal_coax_docsis31_adr_pr_kvha],
		D.[antal_coax_stik_adr_pr_kvha],
		D.[coax_stik_kvhx_state],
		D.[coax_stik_kvhx_state_txt],
		D.[antal_coax_andre_op_pr_kvha],
		D.[max_coax_ds],
		D.[max_coax_us],
		D.[x_mobil],
		D.[y_mobil],
		D.[mobil_indoor_3g],
		D.[mobil_outdoor_3g],
		D.[mobil_indoor_4g],
		D.[mobil_outdoor_4g],
		D.[mobil_indoor],
		D.[mobil_outdoor],
		D.[CTFL_CTR],
		D.[zone],
		D.[LogDatetime],
		D.[ValidFromDatetime],
		GETDATE() AS [ValidToDatetime],
		0 AS [IsCurrent],
		D.[IsDeleted]
	FROM deleted D
	WHERE
		D.[IsCurrent] = 1
END


ALTER TABLE [dbo].[BBR_Daekning_tbl] ENABLE TRIGGER [BBR_Daekning_tbl_AfterUpdateTrigger]
GO
DISABLE TRIGGER [dbo].[BBR_Daekning_tbl_AfterUpdateTrigger]
    ON [dbo].[BBR_Daekning_tbl];


GO



CREATE TRIGGER [dbo].[BBR_Daekning_tbl_IsCurrentTrigger]
   ON  [dbo].[BBR_Daekning_tbl]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	

    UPDATE BD
	SET [IsCurrent] = 0
	FROM [dbo].[BBR_Daekning_tbl] BD
		JOIN inserted I
			ON I.[KVHX] = BD.[KVHX]			
			AND I.[LogDatetime] > BD.[LogDatetime]					
	WHERE
		BD.[IsCurrent] = 1
END
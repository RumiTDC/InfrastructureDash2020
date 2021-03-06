﻿
CREATE VIEW [dbo].[BBR_Daekning]
AS
	SELECT 
		[Kvhx]
		,[DAWA_KVHX]
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
		,[LastChangedDatetime]
		,[ValidFromDatetime]
		,[ValidToDatetime]
		,[IsCurrent]
		,[IsDeleted]
	FROM [dbo].[BBR_Daekning_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[BBR_Daekning] TO [BaseDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[BBR_Daekning] TO [GeneralReportReader]
    AS [dbo];


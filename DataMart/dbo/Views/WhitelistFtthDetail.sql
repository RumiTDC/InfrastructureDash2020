﻿CREATE VIEW [dbo].[WhitelistFtthDetail]
AS
SELECT 
	[kvhx]
	,[kvhx_aws]
	,[KOMMUNENR]
	,[VEJKODE]
	,[GADENAVN]
	,[HUSNUMMER]
	,[HUSBOGSTAV]
	,[ETAGE]
	,[SIDE]
	,[POSTNUMMER]
	,[POSTDISTRIKT]
	,[adgangsadresse_bbrid]
	,[raa_fiber_punkt]
	,[fbsa_punkt]
	,[gpon_punkt]
	,[grave_laengde_m]
	,[kapstik]
	,[bbrkode_txt]
	,[other_network]
	,[dnode]
	,[dongterm]
	,[dongterm_dslam]
	,[kvha]
	,[adr_x]
	,[adr_y]
	,[under30meter]
	,[IND_ID]
	,[IND_DSC]
	,[IND_DDAT]
	,[IND_EFIB]
	,[TDC_DIGG]
	,[rornode_obj_sid]
	,[rornode_x]
	,[rornode_y]
	,[afs_adr_rornode]
	,[closer_node]
	,[closer_x]
	,[closer_y]
	,[afs_closer_node]
	,[antal_bbr]
	,[flere_end_4_bbr]
	,[backhaul_node]
	,[service_reference]
	,[service_node1]
	,[dslam1]
	,[service_node2]
	,[dslam2]
	,[service_node3]
	,[dslam3]
	,[TECH_TYP]
	,[flexibility_point]
	,[flexibility_x]
	,[flexibility_y]
	,[afs_flexpoint_rornode]
	,[afs_flexpoint_adr]
	,[gpon_splitter]
	,[gpon_dslam]
	,[gpon_splitter_dslam]
	,[optisk_krydsfelt]
	,[kapstik_id]
	,[kapstik_flex_point]
	,[kapstik_service_id]
	,[antal_coax_bb_adr_pr_kvha]
	,[antal_coax_stik_adr_pr_kvha]
	,[coax_tv_kunde]
	,[coax_bb_kunde]
	,[infrastruktur_type]
	,[deselection_reason]
	,[deselection_reason_date]
	,[infrastruktur_tekst]
	,[deselection_reason_tekst]
	,[yousee_bb_mulighed_kvha]
	,[grave_laengde_over_30m]
	,[raa_fiber_punkt_prio]
	,[fbsa_punkt_prio]
	,[raa_fiber_punkt_dok_type]
	,[fbsa_punkt_dok_type]
	,[raa_fiber_punkt_kat_type]
	,[fbsa_punkt_kat_type]
	,[backhaul_node_gpon]
	,[adr_gpon_enabled]
	,[raa_fiber_punkt_gpon]
	,[fbsa_punkt_gpon]
	,[fbsa_punkt_org]
	,[LogTime]
FROM [dbo].[WhitelistFtthDetail_tbl] WITH(NOLOCK)
GO
GRANT SELECT
    ON OBJECT::[dbo].[WhitelistFtthDetail] TO [BaseDataReader]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[WhitelistFtthDetail] TO [GeneralReportReader]
    AS [dbo];


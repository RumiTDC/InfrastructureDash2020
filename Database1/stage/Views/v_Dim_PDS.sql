
CREATE view stage.v_Dim_PDS AS

with PDS as (
Select
	BK_PDS=KVHX,
	Kvhx=KVHX,
	PDS_Operatør
from [csv].[PDSKabling]
)

Select
	--BK_PDS=Cast(BK_PDS as nvarchar(25)) --Blanked out RUMI 05-12, ikke i kildetabel,
	Kvhx,
	PDS_Operatør
from [csv].[PDSKabling]
group by --BK_PDS,  --Blanked out RUMI 05-12, ikke i kildetabel,
Kvhx , PDS_Operatør;
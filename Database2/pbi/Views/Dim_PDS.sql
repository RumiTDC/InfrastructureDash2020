
CREATE view pbi.Dim_PDS as 

Select
PDS_Key,
Kvhx,
PDS_Operatør,
PDS=
Case
	when len(PDS_Key)>3 Then 'Ja' -- Blanks og Unknowns bliver Nej ellers ja
	Else 'Nej'
End

from
edw.Dim_PDS
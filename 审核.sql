SELECT
	a.wfInstID,
	a.discPermitEncod,
	a.discPermitEncodOut,
	a.enteID,
	b.enteName,
	c.indTypeCode,
	'行业类别名称' indTypeName,
	a.permitCate,
	f.`dicName` `permitCateName`,
	a.applyState,
	e.dicName applyStateName,
	c.prodBusiAdd,
	b.contactNumber,
	a.`applyStatus`,
	a.applyDate,
	a.taSo2,
	a.taNox,
	a.taCODcr,
	a.taAN,
	a.endLmtDate - now() `remainDays`
FROM
	epe_discharge_permit a
JOIN t_bas_enterprise b ON b.enteID = a.enteID
JOIN t_bas_ente_envir_info c ON c.enteEnvirInfoID = a.enteID
JOIN t_epc_dicdata e ON e.typeCode = 'applyState'
AND e.dicVal = a.applyState
JOIN t_epc_dicdata f ON f.typeCode = 'permitCate'
AND f.dicVal = a.applyStatus
WHERE
	find_in_set(a.applyState ,'300,310')
AND (
	'220281' IS NULL
	OR '220281' = ''
	OR c.ctCode LIKE '220281'
)
AND c.indTypeCode LIKE '%'
AND b.`enteName` LIKE '%'
AND a.`discPermitEncod` LIKE '%'
AND EXISTS (
	SELECT
		1
	FROM
		t_epc_wf_auditor t2
	WHERE
		FIND_IN_SET(t2.taskState ,'20')
	AND t2.discPermitEncod = a.discPermitEncod
	AND (
		'ae5119ed-1457-427e-bb09-9acd3b802772' = ''
		OR 'ae5119ed-1457-427e-bb09-9acd3b802772' IS NULL
		OR t2.auditorID = 'ae5119ed-1457-427e-bb09-9acd3b802772'
	)
)
BEgin TRANSACTION

insert into CuttingFormCylinders
select 
DATA.CuttingFormsId,
C.Id CylindersId
 from (
  select distinct 
  CF.ID CuttingFormsID,
 CASE CF.Code
when	'0001'	then 	'94'
when	'0002'	then 	'78'
when	'0003'	then 	'94'
when	'0004'	then 	'94'
when	'0005'	then 	'94'
when	'0006'	then 	'94'
when	'0008'	then 	'78'
when	'0009'	then 	'78'
when	'0010'	then 	'96'
when	'0011'	then 	'89'
when	'0012'	then 	'94'
when	'0013'	then 	'78'
when	'0014'	then 	'78'
when	'0015'	then 	'94'
when	'0016'	then 	'94'
when	'0017'	then 	'78'
when	'0018'	then 	'78'
when	'0019'	then 	'94'
when	'0020'	then 	'96'
when	'0021'	then 	'89'
when	'0022'	then 	'89'
when	'0023'	then 	'94'
when	'0024'	then 	'78'
when	'0025'	then 	'78'
when	'0026'	then 	'94'
when	'0027'	then 	'89'
when	'0028'	then 	'94'
when	'0029'	then 	'89'
when	'0030'	then 	'78'
when	'0031'	then 	'78'
when	'0032'	then 	'78'
when	'0033'	then 	'94'
when	'0034'	then 	'89'
when	'0035'	then 	'94'
when	'0036'	then 	'94'
when	'0037'	then 	'89'
when	'0038'	then 	'78'
when	'0039'	then 	'96'
when	'0040'	then 	'78'
when	'0041'	then 	'78'
when	'0042'	then 	'94'
when	'0043'	then 	'94'
when	'0044'	then 	'96'
when	'0045'	then 	'78'
when	'0046'	then 	'94'
when	'0047'	then 	'94'
when	'0048'	then 	'94'
when	'0049'	then 	'94'
when	'0050'	then 	'94'
when	'0051'	then 	'89'
when	'0052'	then 	'78'
when	'0053'	then 	'78'
when	'0054'	then 	'94'
when	'0055'	then 	'94'
when	'0056'	then 	'94'
when	'0057'	then 	'94'
when	'0058'	then 	'78'
when	'0059'	then 	'78'
when	'0060'	then 	'78'
when	'0061'	then 	'89'
when	'0062'	then 	'78'
when	'0063'	then 	'96'
when	'0064'	then 	'96'
when	'0065'	then 	'89'
when	'0066'	then 	'94'
when	'0067'	then 	'78'
when	'0068'	then 	'94'
when	'0069'	then 	'78'
when	'0070'	then 	'89'
when	'0071'	then 	'78'
when	'0072'	then 	'78'
when	'0073'	then 	'78'
when	'0074'	then 	'78'
when	'0075'	then 	'94'
when	'0076'	then 	'94'
when	'0077'	then 	'94'
when	'0078'	then 	'89'
when	'0079'	then 	'96'
when	'0080'	then 	'78'
when	'0081'	then 	'94'
when	'0082'	then 	'96'
when	'0083'	then 	'78'
when	'0084'	then 	'78'
when	'0085'	then 	'89'
when	'0086'	then 	'78'
when	'0087'	then 	'78'
when	'0088'	then 	'96'
when	'0089'	then 	'89'
when	'0090'	then 	'94'
when	'0091'	then 	'78'
when	'0092'	then 	'78'
when	'0093'	then 	'78'
when	'0094'	then 	'96'
when	'0095'	then 	'78'
when	'0096'	then 	'78'
when	'0097'	then 	'78'
when	'0098'	then 	'94'
when	'0099'	then 	'78'
when	'0100'	then 	'94'
when	'0101'	then 	'96'
when	'0102'	then 	'89'
when	'0103'	then 	'78'
when	'0104'	then 	'78'
when	'0105'	then 	'78'
when	'0106'	then 	'94'
when	'0107'	then 	'78'
when	'0108'	then 	'96'
when	'0109'	then 	'96'
when	'0110'	then 	'96'
when	'0111'	then 	'94'
when	'0112'	then 	'78'
when	'0113'	then 	'96'
when	'0115'	then 	'96'
when	'0116'	then 	'78'
when	'0117'	then 	'94'
when	'0118'	then 	'96'
when	'0119'	then 	'89'
when	'0120'	then 	'78'
when	'0121'	then 	'94'
when	'0122'	then 	'78'
when	'0123'	then 	'94'
when	'0124'	then 	'89'
when	'0125'	then 	'89'
when	'0128'	then 	'96'
when	'0129'	then 	'89'
when	'0130'	then 	'78'
when	'0131'	then 	'78'
when	'0132'	then 	'96'
when	'0133'	then 	'78'
when	'0134'	then 	'89'
when	'0135'	then 	'94'
when	'0136'	then 	'78'
when	'0137'	then 	'89'
when	'0138'	then 	'89'
when	'0139'	then 	'78'
when	'0140'	then 	'94'
when	'0141'	then 	'78'
when	'0142'	then 	'78'
when	'0143'	then 	'96'
when	'0144'	then 	'96'
when	'0145'	then 	'89'
when	'0146'	then 	'89'
when	'0147'	then 	'96'
when	'0148'	then 	'78'
when	'0149'	then 	'96'
when	'0150'	then 	'94'
when	'0151'	then 	'96'
when	'0152'	then 	'89'
when	'0153'	then 	'89'
when	'0154'	then 	'78'
when	'0155'	then 	'94'
when	'0156'	then 	'78'
when	'0157'	then 	'78'
when	'0158'	then 	'78'
when	'0159'	then 	'78'
when	'0160'	then 	'96'
when	'0161'	then 	'96'
when	'0162'	then 	'78'
when	'0163'	then 	'78'
when	'0164'	then 	'94'
when	'0165'	then 	'96'
when	'0166'	then 	'89'
when	'0167'	then 	'96'
when	'0168'	then 	'94'
when	'0169'	then 	'78'
when	'0170'	then 	'94'
when	'0171'	then 	'78'
when	'0172'	then 	'94'
when	'0173'	then 	'94'
when	'0174'	then 	'94'
when	'0175'	then 	'94'
when	'0176'	then 	'78'
when	'0177'	then 	'78'
when	'0178'	then 	'89'
when	'0179'	then 	'96'
when	'0180'	then 	'96'
when	'0181'	then 	'96'
when	'0182'	then 	'78'
when	'0183'	then 	'94'
when	'0184'	then 	'78'
when	'0185'	then 	'89'
when	'0186'	then 	'89'
when	'0187'	then 	'89'
when	'0188/a'	then 	'78'
when	'0188'	then 	'89'
when	'0189'	then 	'78'
when	'0190'	then 	'78'
when	'0191'	then 	'94'
when	'0192'	then 	'78'
when	'0193'	then 	'78'
when	'0194'	then 	'78'
when	'0195'	then 	'78'
when	'0196'	then 	'78'
when	'0197'	then 	'89'
when	'0198'	then 	'78'
when	'0199'	then 	'78'
when	'0200'	then 	'89'
when	'0201'	then 	'89'
when	'0202'	then 	'96'
when	'0203'	then 	'78'
when	'0204'	then 	'96'
when	'0205'	then 	'94'
when	'0206'	then 	'89'
when	'0207'	then 	'78'
when	'0208'	then 	'78'
when	'0209'	then 	'89'
when	'0210'	then 	'94'
when	'0211'	then 	'96'
when	'0212'	then 	'89'
when	'0213'	then 	'78'
when	'0214'	then 	'96'
when	'0215'	then 	'96'
when	'0216'	then 	'89'
when	'0217'	then 	'96'
when	'0218'	then 	'78'
when	'0219'	then 	'78'
when	'0220'	then 	'89'
when	'0221'	then 	'89'
when	'0222'	then 	'89'
when	'0223'	then 	'94'
when	'0224'	then 	'96'
when	'0225'	then 	'78'
when	'0226'	then 	'94'
when	'0227'	then 	'78'
when	'0228'	then 	'78'
when	'0229'	then 	'78'
when	'0230'	then 	'78'
when	'0231'	then 	'96'
when	'0232'	then 	'78'
when	'0233'	then 	'89'
when	'0234'	then 	'89'
when	'0235'	then 	'78'
when	'0236'	then 	'94'
when	'0237'	then 	'78'
when	'0238'	then 	'94'
when	'0239'	then 	'78'
when	'0240'	then 	'78'
when	'0241'	then 	'78'
when	'0242'	then 	'78'
when	'0243'	then 	'89'
when	'0244'	then 	'89'
when	'0245'	then 	'78'
when	'0246'	then 	'94'
when	'0247'	then 	'94'
when	'0248'	then 	'78'
when	'0249'	then 	'78'
when	'0250'	then 	'89'
when	'0251'	then 	'94'
when	'0252'	then 	'94'
when	'0253'	then 	'89'
when	'0254'	then 	'94'
when	'0255'	then 	'94'
when	'0256'	then 	'94'
when	'0257'	then 	'96'
when	'0258'	then 	'78'
when	'0259'	then 	'94'
when	'0260'	then 	'94'
when	'0261'	then 	'78'
when	'0262'	then 	'78'
when	'0263'	then 	'94'
when	'0264'	then 	'96'
when	'0265'	then 	'78'
when	'0266'	then 	'94'
when	'0267'	then 	'78'
when	'0268'	then 	'96'
when	'0269'	then 	'89'
when	'0270'	then 	'78'
when	'0271'	then 	'94'
when	'0272'	then 	'94'
when	'0274'	then 	'96'
when	'0275'	then 	'78'
when	'0276'	then 	'94'
when	'0277'	then 	'78'
when	'0278'	then 	'78'
when	'0279'	then 	'94'
when	'0280'	then 	'78'
when	'0281'	then 	'94'
when	'0282'	then 	'78'
when	'0283'	then 	'78'
when	'0284'	then 	'78'
when	'0285'	then 	'89'
when	'0286'	then 	'94'
when	'0287'	then 	'96'
when	'0288'	then 	'78'
when	'0289'	then 	'89'
when	'0290'	then 	'89'
when	'0291'	then 	'96'
when	'0292'	then 	'78'
when	'0293'	then 	'94'
when	'0294'	then 	'78'
when	'0295'	then 	'78'
when	'0296'	then 	'78'
when	'0297'	then 	'78'
when	'0298'	then 	'78'
when	'0299'	then 	'78'
when	'0300'	then 	'78'
when	'0301'	then 	'89'
when	'0302'	then 	'96'
when	'0303'	then 	'78'
when	'0304'	then 	'78'
when	'0305'	then 	'89'
when	'0306'	then 	'89'
when	'0307'	then 	'94'
when	'0308'	then 	'78'
when	'0309'	then 	'78'
when	'0310'	then 	'78'
when	'0311'	then 	'96'
when	'0312'	then 	'89'
when	'0313'	then 	'94'
when	'0314'	then 	'89'
when	'0315'	then 	'89'
when	'0316'	then 	'96'
when	'0317'	then 	'94'
when	'0318'	then 	'89'
when	'0319'	then 	'89'
when	'0320'	then 	'89'
when	'0321'	then 	'96'
when	'0322'	then 	'89'
when	'0323'	then 	'78'
when	'0324'	then 	'96'
when	'0325'	then 	'96'
when	'0326'	then 	'89'
when	'0327'	then 	'96'
when	'0328'	then 	'78'
when	'0329'	then 	'94'
when	'0330'	then 	'89'
when	'0331'	then 	'78'
when	'0332'	then 	'96'
when	'0333'	then 	'89'
when	'0334'	then 	'94'
when	'0335'	then 	'94'
when	'0336'	then 	'89'
when	'0337'	then 	'96'
when	'0338'	then 	'78'
when	'0339'	then 	'89'
when	'0340'	then 	'78'
when	'0341'	then 	'89'
when	'0342'	then 	'96'
when	'0343'	then 	'89'
when	'0344'	then 	'78'
when	'0345'	then 	'78'
when	'0346'	then 	'78'
when	'0347'	then 	'78'
when	'0348'	then 	'89'
when	'0349'	then 	'94'
when	'0350'	then 	'89'
when	'0351'	then 	'89'
when	'0352'	then 	'78'
when	'0353'	then 	'89'
when	'0354'	then 	'89'
when	'0355'	then 	'78'
when	'0356'	then 	'78'
when	'0357'	then 	'78'
when	'0358'	then 	'78'
when	'0359'	then 	'96'
when	'0360'	then 	'78'
when	'0361'	then 	'94'
when	'0362'	then 	'94'
when	'0363'	then 	'94'
when	'0364'	then 	'78'
when	'0365'	then 	'94'
when	'0366'	then 	'89'
when	'0367'	then 	'89'
when	'0368'	then 	'94'
when	'0369'	then 	'94'
when	'0370'	then 	'89'
when	'0371'	then 	'89'
when	'0372'	then 	'94'
when	'0373'	then 	'89'
when	'0374'	then 	'78'
when	'0375'	then 	'89'
when	'0376'	then 	'78'
when	'0377'	then 	'96'
when	'0378'	then 	'94'
when	'0379'	then 	'89'
when	'0380'	then 	'89'
when	'0381'	then 	'89'
when	'0382'	then 	'78'
when	'0383'	then 	'78'
when	'0384'	then 	'78'
when	'0385'	then 	'78'
when	'0386'	then 	'78'
when	'0387'	then 	'78'
when	'0388'	then 	'89'
when	'0389'	then 	'78'
when	'0390'	then 	'78'
when	'0391'	then 	'89'
when	'0392'	then 	'78'
when	'0393'	then 	'89'
when	'0394'	then 	'78'
when	'0395'	then 	'89'
when	'0396'	then 	'96'
when	'0397'	then 	'78'
when	'0398'	then 	'78'
when	'0399'	then 	'94'
when	'0400'	then 	'89'
when	'0401'	then 	'94'
when	'0402'	then 	'64'
when	'0403'	then 	'96'
when	'0404'	then 	'96'
when	'0405'	then 	'89'
when	'0406'	then 	'96'
when	'0407'	then 	'96'
when	'0408'	then 	'94'
when	'0409'	then 	'94'
when	'0410'	then 	'78'
when	'0411'	then 	'96'
when	'0412'	then 	'78'
when	'0413'	then 	'78'
when	'0414'	then 	'78'
when	'0415'	then 	'94'
when	'0416'	then 	'96'
when	'0417'	then 	'96'
when	'0418'	then 	'89'
when	'0419'	then 	'64'
when	'0420'	then 	'89'
when	'0421'	then 	'89'
when	'0422'	then 	'78'
when	'0423'	then 	'78'
when	'0424'	then 	'70'
when	'0425'	then 	'89'
when	'0426'	then 	'96'
when	'0427'	then 	'78'
when	'0428'	then 	'78'
when	'0429'	then 	'89'
when	'0430'	then 	'94'
when	'0431'	then 	'78'
when	'0432'	then 	'96'
when	'0433'	then 	'94'
when	'0434'	then 	'94'
when	'0435'	then 	'94'
when	'0436'	then 	'94'
when	'0437'	then 	'89'
when	'0438'	then 	'78'
when	'0439'	then 	'89'
when	'0440'	then 	'96'
when	'0441'	then 	'64'
when	'0442'	then 	'89'
when	'0443'	then 	'89'
when	'0444'	then 	'78'
when	'0445'	then 	'89'
when	'0446'	then 	'89'
when	'0447'	then 	'94'
when	'0448'	then 	'78'
when	'0449'	then 	'78'
when	'0450'	then 	'78'
when	'0464'	then 	'94'
when	'0465'	then 	'64'
when	'0468'	then 	'78'
when	'0469'	then 	'94'
when	'0470'	then 	'89'
when	'0475'	then 	'78'
when	'0478'	then 	'64'
when	'0479'	then 	'94'
when	'0480'	then 	'64'
when	'0483'	then 	'94'
when	'0484'	then 	'94'
when	'0485'	then 	'78'
when	'0486'	then 	'89'
when	'0487'	then 	'78'
when	'0488'	then 	'64'
when	'0489'	then 	'96'
when	'0490'	then 	'94'
when	'0491'	then 	'64'
when	'0493'	then 	'89'
when	'0494'	then 	'94'
when	'0495'	then 	'64'
when	'0496'	then 	'78'
when	'0497'	then 	'78'
when	'0498'	then 	'81'
when	'0499'	then 	'78'
when	'0503'	then 	'64'
when	'0505'	then 	'96'
when	'0508'	then 	'94'
when	'0509'	then 	'96'
when	'0510'	then 	'94'
when	'0511'	then 	'89'
when	'0512'	then 	'78'
when	'0513'	then 	'89'
when	'0514'	then 	'94'
when	'0521'	then 	'64'
when	'0522'	then 	'96'
when	'0525'	then 	'94'
when	'0528'	then 	'89'
when	'0530'	then 	'89'
when	'0532'	then 	'78'
when	'0534'	then 	'64'
when	'0536'	then 	'89'
when	'0537'	then 	'89'
when	'0541'	then 	'64'
when	'0543'	then 	'64'
when	'0545'	then 	'81'
when	'0546'	then 	'119'
when	'0547'	then 	'64'
when	'0548'	then 	'94'
when	'0549'	then 	'64'
when	'0552'	then 	'81'
when	'0553'	then 	'64'
when	'0554'	then 	'94'
when	'0555'	then 	'64'
when	'0557'	then 	'70'
when	'0559'	then 	'89'
when	'0561'	then 	'89'
when	'0564'	then 	'89'
when	'0569'	then 	'119'
when	'0571'	then 	'89'
when	'0575'	then 	'70'
when	'0578'	then 	'119'
when	'0581'	then 	'78'
when	'0582'	then 	'77'
when	'0584'	then 	'81'
when	'0585'	then 	'110'
when	'0587'	then 	'89'
when	'0590'	then 	'81'
when	'0596'	then 	'81'
when	'0598'	then 	'96'
when	'0600'	then 	'97'
when	'0601'	then 	'64'
when	'0602'	then 	'94'
when	'0603'	then 	'97'
when	'0604'	then 	'70'
when	'0606'	then 	'94'
when	'0617'	then 	'70'
when	'0619'	then 	'97'
when	'0620'	then 	'81'
when	'0621'	then 	'70'
when	'0622'	then 	'77'
when	'0630'	then 	'85'
when	'0633'	then 	'70'
when	'0634'	then 	'77'
when	'0635'	then 	'70'
when	'0640'	then 	'77'
when	'0641'	then 	'70'
when	'0642'	then 	'77'
when	'0644'	then 	'97'
when	'0647'	then 	'110'
when	'0648'	then 	'81'
when	'0649'	then 	'70'
when	'0651'	then 	'70'
when	'0652'	then 	'81'
when	'0653'	then 	'81'
when	'0654'	then 	'85'
when	'0655'	then 	'77'
when	'0656'	then 	'77'
when	'0657'	then 	'94'
when	'0658'	then 	'96'
when	'0659'	then 	'64'
when	'0660'	then 	'70'
when	'0661'	then 	'70'
when	'0662'	then 	'85'
when	'0663'	then 	'70'
when	'0664'	then 	'97'
when	'0667'	then 	'70'
when	'0672'	then 	'96'
when	'0673'	then 	'70'
when	'0678'	then 	'85'
when	'0679'	then 	'97'
when	'0681'	then 	'85'
when	'0683'	then 	'70'
when	'0685'	then 	'77'
when	'0688'	then 	'81'
when	'0690'	then 	'78'
when	'0692'	then 	'70'
when	'0693'	then 	'70'
when	'0694'	then 	'64'
when	'0695'	then 	'70'
when	'0696'	then 	'70'
when	'0697'	then 	'85'
when	'0698'	then 	'81'
when	'0699'	then 	'85'
when	'0700'	then 	'119'
when	'0702'	then 	'70'
when	'0704'	then 	'85'
when	'0705'	then 	'96'
when	'0707'	then 	'81'
when	'0709'	then 	'70'
when	'0711'	then 	'85'
when	'0713'	then 	'77'
when	'0714'	then 	'119'
when	'0715'	then 	'85'
when	'0716'	then 	'70'
when	'0718'	then 	'70'
when	'0719'	then 	'110'
when	'0721'	then 	'70'
when	'0722'	then 	'85'
when	'0723'	then 	'64'
when	'0724'	then 	'70'
when	'0727'	then 	'81'
when	'0730'	then 	'97'
when	'0731'	then 	'97'
when	'0734'	then 	'81'
when	'0735'	then 	'70'
when	'0737'	then 	'97'
when	'0741'	then 	'97'
when	'0749'	then 	'81'
when	'0750'	then 	'81'
when	'0753'	then 	'119'
when	'0754'	then 	'64'
when	'0755'	then 	'97'
when	'0756'	then 	'97'
when	'0758'	then 	'81'
when	'0759'	then 	'81'
when	'0761'	then 	'81'
when	'0762'	then 	'81'
when	'0766'	then 	'81'
when	'0767'	then 	'85'
when	'0768'	then 	'81'
when	'0769'	then 	'81'
when	'0770'	then 	'97'
when	'0771'	then 	'97'
when	'0772'	then 	'110'
when	'0773'	then 	'81'
when	'0775'	then 	'70'
when	'0776'	then 	'97'
when	'0777'	then 	'81'
when	'0780'	then 	'81'
when	'0782'	then 	'110'
when	'0784'	then 	'97'
when	'0785'	then 	'141'
when	'0786'	then 	'97'
when	'0789'	then 	'81'
when	'0792'	then 	'81'
when	'0796'	then 	'97'
when	'0797'	then 	'81'
when	'0799'	then 	'81'
when	'0802'	then 	'70'
when	'0804'	then 	'77'
when	'0805'	then 	'81'
when	'0806'	then 	'70'
when	'0807'	then 	'119'
when	'0812'	then 	'110'
when	'0814'	then 	'81'
when	'0816'	then 	'70'
when	'0817'	then 	'64'
when	'0820'	then 	'97'
when	'0822'	then 	'81'
when	'0825'	then 	'77'
when	'0828'	then 	'97'
when	'0830'	then 	'70'
when	'0832'	then 	'81'
when	'0833'	then 	'81'
when	'0834'	then 	'89'
when	'0836'	then 	'77'
when	'0841'	then 	'77'
when	'0842'	then 	'70'
when	'0843'	then 	'85'
when	'0846'	then 	'70'
when	'0847'	then 	'85'
when	'0848'	then 	'89'
when	'0849'	then 	'94'
when	'0850'	then 	'70'
when	'0854'	then 	'97'
when	'0857'	then 	'89'
when	'0860'	then 	'97'
when	'0862'	then 	'119'
when	'0864'	then 	'110'
when	'0865'	then 	'70'
when	'0868'	then 	'70'
when	'0871'	then 	'110'
when	'0872'	then 	'119'
when	'0877'	then 	'78'
when	'0878'	then 	'81'
when	'0881'	then 	'81'
when	'0882'	then 	'70'
when	'0883'	then 	'70'
when	'0884'	then 	'70'
when	'0890'	then 	'81'
when	'0892'	then 	'81'
when	'0893'	then 	'77'
when	'0907'	then 	'77'
when	'0908'	then 	'70'
when	'0909'	then 	'70'
when	'0910'	then 	'81'
when	'0911'	then 	'119'
when	'0914'	then 	'119'
when	'0916'	then 	'85'
when	'0918'	then 	'110'
when	'0920'	then 	'81'
when	'0922'	then 	'70'
when	'0924'	then 	'97'
when	'0925'	then 	'119'
when	'0930'	then 	'70'
when	'0932'	then 	'70'
when	'0934'	then 	'81'
when	'0936'	then 	'97'
when	'0937'	then 	'81'
when	'0938'	then 	'64'
when	'0939'	then 	'110'
when	'0940'	then 	'110'
when	'0943'	then 	'70'
when	'0947'	then 	'110'
when	'0948'	then 	'110'
when	'0951'	then 	'97'
when	'0954'	then 	'97'
when	'0957'	then 	'89'
when	'0958'	then 	'97'
when	'0959'	then 	'96'
when	'0960'	then 	'70'
when	'0961'	then 	'81'
when	'0962'	then 	'81'
when	'0963'	then 	'81'
when	'0965'	then 	'97'
when	'0971'	then 	'97'
when	'0974'	then 	'85'
when	'0979'	then 	'110'
when	'0980'	then 	'70'
when	'0981'	then 	'70'
when	'0986'	then 	'85'
when	'0987'	then 	'97'
when	'0990'	then 	'70'
when	'0991'	then 	'89'
when	'0994'	then 	'70'
when	'0996'	then 	'70'
when	'0998'	then 	'119'
when	'1000'	then 	'110'
when	'1006'	then 	'70'
when	'1007'	then 	'96'
when	'1011'	then 	'70'
when	'1012'	then 	'81'
when	'1018'	then 	'81'
when	'1019'	then 	'81'
when	'1020'	then 	'119'
when	'1021'	then 	'77'
when	'1022'	then 	'77'
when	'1024'	then 	'70'
when	'1025'	then 	'70'
when	'1026'	then 	'81'
when	'1027'	then 	'89'
when	'1030'	then 	'97'
when	'1031'	then 	'97'
when	'1032'	then 	'70'
when	'1033'	then 	'81'
when	'1034'	then 	'97'
when	'1035'	then 	'97'
when	'1037'	then 	'70'
when	'1039'	then 	'110'
when	'1040'	then 	'70'
when	'1041'	then 	'77'
when	'1042'	then 	'110'
when	'1047'	then 	'77'
when	'1048'	then 	'97'
when	'1049'	then 	'97'
when	'1050'	then 	'97'
when	'1051'	then 	'97'
when	'1054'	then 	'110'
when	'1055'	then 	'119'
when	'1056'	then 	'119'
when	'1057'	then 	'81'
when	'1060'	then 	'70'
when	'1062'	then 	'110'
when	'1067'	then 	'64'
when	'1068'	then 	'77'
when	'1069'	then 	'77'
when	'1070'	then 	'70'
when	'1073'	then 	'81'
when	'1080'	then 	'110'
when	'1081'	then 	'70'
when	'1084'	then 	'70'
when	'1088'	then 	'70'
when	'1090'	then 	'70'
when	'1092'	then 	'77'
when	'1094'	then 	'110'
when	'1095'	then 	'81'
when	'1098'	then 	'77'
when	'1099'	then 	'70'
when	'1100'	then 	'89'
when	'1101'	then 	'119'
when	'1102'	then 	'70'
when	'1104'	then 	'77'
when	'1105'	then 	'81'
when	'1106'	then 	'81'
when	'1112'	then 	'110'
when	'1113'	then 	'64'
when	'1114'	then 	'70'
when	'1118'	then 	'70'
when	'1119'	then 	'81'
when	'1120'	then 	'97'
when	'1125'	then 	'70'
when	'1130'	then 	'77'
when	'1131'	then 	'70'
when	'1132'	then 	'85'
when	'1133'	then 	'110'
when	'1135'	then 	'70'
when	'1136'	then 	'70'
when	'1137'	then 	'70'
when	'1138'	then 	'70'
when	'1139'	then 	'70'
when	'1140'	then 	'70'
when	'1141'	then 	'77'
when	'1142'	then 	'77'
when	'1143'	then 	'119'
when	'1147'	then 	'97'
when	'1148'	then 	'78'
when	'1149'	then 	'64'
when	'1150'	then 	'97'
when	'1151'	then 	'81'
when	'1152'	then 	'97'
when	'1154'	then 	'81'
when	'1155'	then 	'70'
when	'1157'	then 	'77'
when	'1160'	then 	'85'
when	'1162'	then 	'81'
when	'1164'	then 	'97'
when	'1165'	then 	'81'
when	'1168'	then 	'85'
when	'1169'	then 	'77'
when	'1170'	then 	'119'
when	'1172'	then 	'70'
when	'1173'	then 	'110'
when	'1176'	then 	'97'
when	'1177'	then 	'97'
when	'1178'	then 	'96'
when	'1179'	then 	'110'
when	'1182'	then 	'77'
when	'1183'	then 	'70'
when	'1185'	then 	'97'
when	'1187'	then 	'77'
when	'1191'	then 	'81'
when	'1192'	then 	'110'
when	'1194'	then 	'77'
when	'1195'	then 	'77'
when	'1196'	then 	'97'
when	'1199'	then 	'77'
when	'1200'	then 	'110'
when	'1201'	then 	'70'
when	'1204'	then 	'70'
when	'1205'	then 	'97'
when	'1206'	then 	'81'
when	'1207'	then 	'77'
when	'1208'	then 	'81'
when	'1209'	then 	'77'
when	'1210'	then 	'97'
when	'1211'	then 	'97'
when	'1218'	then 	'77'
when	'1219'	then 	'77'
when	'1220'	then 	'81'
when	'1223'	then 	'85'
when	'1224'	then 	'81'
when	'1225'	then 	'119'
when	'1228'	then 	'77'
when	'1229'	then 	'110'
when	'1230'	then 	'85'
when	'1233'	then 	'97'
when	'1234'	then 	'70'
when	'1235'	then 	'119'
when	'1237'	then 	'97'
when	'1240'	then 	'96'
when	'1241'	then 	'97'
when	'1242'	then 	'70'
when	'1243'	then 	'70'
when	'1244'	then 	'85'
when	'1245'	then 	'70'
when	'1247'	then 	'97'
when	'1248'	then 	'110'
when	'1249'	then 	'70'
when	'1250'	then 	'81'
when	'1251'	then 	'70'
when	'1253'	then 	'97'
when	'1254'	then 	'81'
when	'1256'	then 	'97'
when	'1258'	then 	'70'
when	'1259'	then 	'97'
when	'1261'	then 	'81'
when	'1266'	then 	'119'
when	'1267'	then 	'85'
when	'1268'	then 	'97'
when	'1271'	then 	'81'
when	'1276'	then 	'77'
when	'1277'	then 	'97'
when	'1278'	then 	'97'
when	'1281'	then 	'97'
when	'1283'	then 	'97'
when	'1286'	then 	'81'
when	'1287'	then 	'97'
when	'1289'	then 	'81'
when	'1292'	then 	'70'
when	'1293'	then 	'119'
when	'1295'	then 	'97'
when	'1297'	then 	'119'
when	'1302'	then 	'97'
when	'1303'	then 	'85'
when	'1304'	then 	'70'
when	'1305'	then 	'110'
when	'1309'	then 	'77'
when	'1310'	then 	'81'
when	'1321'	then 	'81'
when	'1323'	then 	'97'
when	'1325'	then 	'110'
when	'1327'	then 	'97'
when	'1329'	then 	'97'
when	'1330'	then 	'110'
when	'1333'	then 	'110'
when	'1334'	then 	'81'
when	'1335'	then 	'110'
when	'1336'	then 	'70'
when	'1337'	then 	'119'
when	'1338'	then 	'85'
when	'1339'	then 	'85'
when	'1340'	then 	'97'
when	'1341'	then 	'119'
when	'1343'	then 	'97'
when	'1345'	then 	'85'
when	'1348'	then 	'81'
when	'1353'	then 	'119'
when	'1356'	then 	'77'
when	'1357'	then 	'110'
when	'1358'	then 	'81'
when	'1359'	then 	'81'
when	'1360'	then 	'97'
when	'1361'	then 	'81'
when	'1369'	then 	'70'
when	'1370'	then 	'81'
when	'1371'	then 	'77'
when	'1372'	then 	'97'
when	'1373'	then 	'77'
when	'1554'	then 	'110'
when	'1550'	then 	'141'
when	'1551'	then 	'141'
when	'1648'	then 	'81'
when	'1648'	then 	'119'
when	'1412'	then 	'85'
when	'1284'	then 	'85'
when	'1572'	then 	'119'


ELSE NULL END Gears
 from CuttingForms CF
)DATA
inner join Cylinders C on DATA.Gears = C.Gears
ROLLBACK

begin TRANSACTION
delete from CuttingFormCylinders
ROLLBACK
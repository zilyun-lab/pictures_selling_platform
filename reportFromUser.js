const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require('nodemailer');
const cors = require('cors')({origin: true});
admin.initializeApp();

let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'massaru1221@gmail.com',
        pass: 'Massaru19991221'
    }
});

exports.onCreateActivityReportFromUser = functions.firestore
.document('/report/{reportID}')
.onCreate(async (snapshot, context) =>
{
    const doc = await repotRef.get();
    // const userId = (uid);
    const repotRef = admin.firestore().doc(`report/${reportID}`);
   


    const reportFrom = repotRef.userName;
    const reportFromID = repotRef.reportFromID;
    const data = snapshot.data();
    const burnTo = repotRef.burnToName;
    const burnToID = repotRef.burnToID;
    

    if(reportFrom)
    {
        sendEmail("massaru1221@gmail.com", "Massaru19991221");
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    exports.sendMail = functions.https.onRequest((req, res) => {
        cors(req, res, () => {
          
            // getting dest email by query string
            const dest = req.query.dest;
    
            const mailOptions = {
                from: 'Your Account Name <yourgmailaccount@gmail.com>', // Something like: Jane Doe <janedoe@gmail.com>
                to: dest,
                subject: 'test', // email subject
                html: `<p style="font-size: 16px;">${
                    repotRef.userName
                }</p>
                    <br />
                    <img src="https://images.prod.meredith.com/product/fc8754735c8a9b4aebb786278e7265a5/1538025388228/l/rick-and-morty-pickle-rick-sticker" />
                ` // email content in HTML
            };
      
            // returning result
            return transporter.sendMail(mailOptions, (erro, info) => {
                if(erro){
                    return res.send(erro.toString());
                }
                return res.send('Sended');
            });
        });    
    });
});

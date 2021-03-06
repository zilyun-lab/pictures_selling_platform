const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const admin = require('firebase-admin');
admin.initializeApp();
const gmailEmail = "massaru1221@gmail.com";
const gmailPassword = "take3r12";


exports.sendReportEmail = functions.firestore
    .document('report/{reportID}')
    .onCreate((snap, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "user-report@leewayjp.net",
                pass: gmailPassword,
            }
          });
          

        const mailOptions = {
            from: "user-report@leewayjp.net",
            to: snap.data().email,
            subject: 'ユーザーからの報告があります',
            html: `<p>
                                   <b>報告対象ユーザー: </b>${snap.data().burnToID}<br>
                                   <b>報告内容: </b>${snap.data().message}<br>
                                   <b>報告理由: </b>${snap.data().why}<br>
                                   <b>通知者: </b>${snap.data().reportFrom}<br>
                                </p>`
        };


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
});


exports.sendCancelEmail = functions.firestore
    .document('cancelReport/{cancelID}')
    .onCreate((snap, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "cancel-order@leewayjp.net",
                pass: gmailPassword,
            }
          });
        const mailOptions = {
            from: "cancel-order@leewayjp.net",
            to: "cancel-order@leewayjp.net",
            subject: 'ユーザーよりキャンセルがありました。',
            html: `<p>
                                   <b>キャンセル申請ユーザー: </b>${snap.data().CancelRequestName}<br>
                                   <b>キャンセル申請ユーザー: </b>${snap.data().whoCancelRequestID}<br>
                                   <b>申請理由: </b>${snap.data().reason}<br>
                                   <b>任意の申請理由: </b>${snap.data().why}<br>
                                   <b>注文ID: </b>${snap.data().orderID}<br>
                                </p>`
        };
        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
});


exports.sendEmailToNewUser = functions.firestore
    .document('users/{userID}')
    .onCreate((snap, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });

        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: snap.data().email,
            subject: 'アカウント登録完了のお知らせ',
            html: `<p>${snap.data().name} 様<br><br>アカウント登録ありがとうございます！<br><br>LEEWAYは絵画、ステッカーなど専用の販売サービス<br><br>自分で描いた絵やオリジナルのステッカーを販売し、お気に入りの商品を購入しましょう！</p>
            <br>
            <img src="https://firebasestorage.googleapis.com/v0/b/selling-pictures.appspot.com/o/isColor_Horizontal.png?alt=media&token=ad01809b-03ff-4126-9eaf-08d429ec2791">
            <br><br><br>
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net</p>
            <br>
            <hr noshade>`
        };


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
});


exports.sendEmailToSeller = functions.firestore
    .document('users/{userID}/Notify/{notifyID}')
    .onCreate(async (snap, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });
        const userIds = context.params.userID;
        
        const userRefs = admin.firestore().doc(`users/${userIds}`);
        const docs = await userRefs.get();

        const dateTimeOfBought = new Date(snap.data().orderTime * 1000);
        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: snap.data().email,
            subject: '作品が購入されました',
            html: `<p>${docs.data().name} 様<br><br>${snap.data().orderBy}様より、商品が購入されました。<br><br>発送の準備を始めましょう。</p><br>
            <br>
            <p>ご注文ID：${snap.data().id}</p>
            <p>ご注文日：${dateTimeOfBought.toString()}</p>
            <p>商品名：${snap.data().productIDs}</p>
            <br><br>
            <p>お届け先</p>
            <span style="color: red">* </span>
            <span>お届け先は個人情報のため発送の際にのみ、アプリ内取引ページにて確認いただけます。</span>
            
            <br>
            <hr style="border:none;border-top:dashed 1px #000000;height:1px;color:#FFFFFF;">
            <br>
            <p>注文後は出品者とのチャットが利用できます。</p>
            <p>何かありましたら、取引ページより出品者に連絡をしてください。</p>
            <br><br>
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net/p>
            <br>
            <hr noshade>`
        };


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
});




exports.sendEmailToBuyer = functions.firestore
    .document('users/{userID}/orders/{OrderID}')
    .onCreate(async (snap, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });
        const userId = context.params.userID;
        const userRef = admin.firestore().doc(`users/${userId}`);
        const doc = await userRef.get();
        const buyerName = doc.data().name;
        const buyerAddressID = snap.data().addressID;

        const dateTimeOfBought = new Date(snap.data().orderTime );
        
        const year = dateTimeOfBought.toLocaleDateString('ja-JP').slice(0,4);
        const month = dateTimeOfBought.toLocaleDateString('ja-JP').slice(5,6);
        const day = dateTimeOfBought.toLocaleDateString('ja-JP').slice(7);
        const hour = dateTimeOfBought.toLocaleTimeString('ja-JP').slice(0,2);
        const minute = dateTimeOfBought.toLocaleTimeString('ja-JP').slice(3,5);
        const addressRef = admin.firestore().doc(`users/${userId}/userAddress/${buyerAddressID}`);
        const addressDoc = await addressRef.get();


        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: snap.data().email,
            subject: '注文内容の確認',
            html: `
            <p>${buyerName} 様<br><br>ご注文頂きまして、誠にありがとうございます。<br><br>決済内容の確認です。</p><br>
            
            <br>
            <p>ご注文ID：${snap.id}</p>
            <p>ご注文日：${year}年${month}月${day}日 ${hour}時${minute}分</p>
            <p>商品名：${snap.data().productIDs}</p>
            <p>支払金額：${snap.data().totalPrice}</p>
            <br><br>
            <p>お届け先</p>
            
            <p>氏名：${addressDoc.data().lastName} ${addressDoc.data().firstName}</p>
            <p>郵便番号：${addressDoc.data().postalCode}</p>
            <p>住所：${addressDoc.data().prefectures}${addressDoc.data().city}${addressDoc.data().address}${addressDoc.data().secondAddress}</p>
          
            <br>
            <hr style="border:none;border-top:dashed 1px #000000;height:1px;color:#FFFFFF;">
            <br>
            <p>注文後は出品者とのチャットが利用できます。</p>
            <p>何かありましたら、取引ページより出品者に連絡をしてください。</p>
            <br><br>
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net</p>
            <br>
            <hr noshade>`
        };


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
});



exports.sendEmailWhenTransactionFinished = functions.firestore
    .document('users/{userID}/Notify/{notifyID}')
    .onUpdate(async(change, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });
        const userId = context.params.userID;
        const userRef = admin.firestore().doc(`users/${userId}`);
        const doc = await userRef.get();
        const sellerName = doc.data().name;

        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: change.after.data().email,
            subject: '取引終了のお知らせと口座登録のお願い',
            html: `<p>${sellerName} 様<br><br>取引が完了し、売上金を反映いたしました。<br>
            <br>
            <p>ご注文ID：${change.after.data().id}</p>
            <p>商品名：${change.after.data().productIDs}</p>
            <p>売上金：${change.after.data().finalGetProceeds}</p>
            <br>
            <hr style="border:none;border-top:dashed 1px #000000;height:1px;color:#FFFFFF;">
            <br>
            <p>[口座登録のお願い]</p>
            <ul>
            <li>売上金の振り込み申請は90日以内でお願いしています。</li>
            <li>マイページで振込口座を登録し、振込申請をお願いいたします。<br><span style="color: red">* </span><span>振込スケジュール、振込手数料は「よくある質問」から確認できます。</span></li>
            </ul>
            <br>
            
            
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net</p>
            <br>
            <hr noshade>`
                                
        };

        if(change.after.data().isTransactionFinished === "Complete"){


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
    }
});





exports.sendEmailWhenCancelFinishedToSeller = functions.firestore
    .document('users/{userID}/Notify/{notifyID}')
    .onUpdate((change, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });
        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: change.after.data().email,
            subject: '取引キャンセル完了のお知らせ',
            html: `<p>${change.after.data().boughtFrom} 様<br><br>${change.after.data().orderBy} 様との取引のキャンセルの申請を確認し、キャンセルが成立しました。<br>
            <br>
            <p>ご注文ID：${change.after.data().id}</p>
            <p>商品名：${change.after.data().productIDs}</p>
            <br>
            
            <br>
            
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net</p>
            <br>
            <hr noshade>`
                                
        };

        if(change.after.data().cancelTransactionFinished === true){


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
    }
});


exports.sendEmailWhenCancelFinishedToBuyer = functions.firestore
    .document('users/{userID}/orders/{OrderID}')
    .onUpdate((change, context) => {
        var transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 587,
            secure: false,
            
            auth: {
                user: "no-reply@leewayjp.net",
                pass: gmailPassword,
            }
          });

        const mailOptions = {
            from: `no-reply@leewayjp.net`,
            to: change.after.data().email,
            subject: '取引キャンセル完了のお知らせ',
            html: `<p>${change.after.data().orderByName} 様<br><br>${change.after.data().postName} 様との取引のキャンセルの申請を確認し、キャンセルが成立しました。<br>
            <br>
            <p>ご注文ID：${change.after.data().id}</p>
            <p>商品名：${change.after.data().productIDs}</p>
            <p>返金予定額：${change.after.data().totalPrice*0.964}円</p>
            <span style="color: red">* </span>
            <span>お届け先は個人情報のため発送の際にのみ、アプリ内取引ページにて確認いただけます。</span>
            <br>
            
            <br>
            
            <hr noshade>
            <p><br>絵画専門サービス LEEWAY運営<br><br><br>本メールは送信専用のため、返信をいただきましてもお答え出来かねます。<br><br>お問い合わせは下記アドレスまでお願いいたします。<br>Email: contact@leewayjp.net</p>
            <br>
            <hr noshade>`
                                
        };

        if(change.after.data().cancelTransactionFinished === true){


        return transporter.sendMail(mailOptions, (error, data) => {
            if (error) {
                console.log(error)
                return
            }
            console.log("Sent!")
        });
    }
});



exports.onCreateChat = functions.firestore
.document('/users/{userId}/chat/{chatId}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = snapshot.data();

    if(messageToken)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, activityFeedItem)
    {
        let body;

        title = "[メッセージが届いています]";
        body = `${activityFeedItem.user_name} 様よりメッセージが届いています。\nチャットにて確認してみましょう`;

        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});



exports.onCreatePNFromAdmin = functions.firestore
.document('/users/{userId}/AllNotify/{AllNotifyId}/From Admin/{AdminMessege}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = snapshot.data();

    if(messageToken)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, activityFeedItem)
    {
        let body;

        title = `運営からのメッセージ`;
        body = activityFeedItem.message;

        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});


exports.onCreatePNToSeller = functions.firestore
.document('/users/{userId}/Notify/{NotifyId}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = snapshot.data();

    
    if(messageToken)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const orderByName = createActivityFeedItem.orderByName;
        const itemName = createActivityFeedItem.productIDs;

        title = "[取引開始のお知らせ]";

        body = `${orderByName} 様より 「${itemName}」をご注文いただきました。\n発送を行いましょう。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});


exports.onCreatePNToBuyer = functions.firestore
.document('/users/{userId}/orders/{OrderId}')
.onCreate(async (snapshot, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = snapshot.data();

    
    if(messageToken)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const itemName = createActivityFeedItem.productIDs;


        title = "[取引開始のお知らせ]";
        body = `「${itemName}」をご注文いただきありがとうございます。\n商品の発送をお待ち下さい。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});



exports.onCreatePNToBuyerWhenShipsDetail = functions.firestore
.document('/users/{userId}/orders/{OrderId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.isDelivery === "Complete" )
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const sellerName = createActivityFeedItem.postName;
        const itemName = createActivityFeedItem.productIDs;

        title = "[発送完了のお知らせ]";
        body = `${sellerName} 様より「${itemName}」が発送されました。\n受け取り次第、作者の評価を行いましょう！`;
    
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});


exports.onCreatePNToSellerWhenReviewSeller = functions.firestore
.document('/users/{userId}/Notify/{NotifyId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.isBuyerDelivery === "Complete" && createActivityFeedItem.isTransactionFinished === "Complete")
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const buyerName = createActivityFeedItem.orderByName;
        const itemName = createActivityFeedItem.productIDs;

        title = "[取引完了のお知らせ]";
        body = `${buyerName} 様より「${itemName}」がの評価をいただきました。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});


exports.onCreatePNToBuyerWhenFinishedOrder = functions.firestore
.document('/users/{userId}/orders/{OrderId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.isDelivery === "Complete" && createActivityFeedItem.isTransactionFinished === "Complete")
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const sellerName = createActivityFeedItem.postName;
        const itemName = createActivityFeedItem.productIDs;

        title = "[取引完了のお知らせ]";
        body = `${sellerName} 様との取引が完了しました。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});


exports.onCreatePNToBuyerWhenCancelReqouest = functions.firestore
.document('/users/{userId}/orders/{OrderId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.CancelRequestTo === true )
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const sellerName = createActivityFeedItem.postName;
        const itemName = createActivityFeedItem.productIDs;

        
        body = `${sellerName} 様よりキャンセル申請が届いています。\nご確認ください。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});

exports.onCreatePNToBuyerWhenCancelReqouestAgreement = functions.firestore
.document('/users/{userId}/Notify/{NotifyId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.CancelRequest === true && createActivityFeedItem.cancelTransactionFinished === true)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const buyerName = createActivityFeedItem.orderByName;
        const itemName = createActivityFeedItem.productIDs;

        
        body = `${buyerName} 様よりキャンセル申請の同意が完了しました。\nご確認ください。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});

exports.onCreatePNToBuyerWhenCancelReqouestFinished = functions.firestore
.document('/users/{userId}/orders/{OrderId}')
.onUpdate(async (change, context) =>
{
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`users/${userId}`);
    const doc = await userRef.get();


    const messageToken = doc.data().iOSToken;
    const createActivityFeedItem = change.after.data();

    
    if(messageToken && createActivityFeedItem.CancelRequest === true && createActivityFeedItem.cancelTransactionFinished === true)
    {
        sendNotification(messageToken, createActivityFeedItem);
    }
    else
    {
        console.log("No token for user, can not send notification.")
    }

    function sendNotification(messageToken, createActivityFeedItem)
    {
        let body;

        
        const sellerName = createActivityFeedItem.postName;
        const itemName = createActivityFeedItem.productIDs;
        

        body = `${sellerName} 様との取引がキャンセルされました。\nご確認ください。`;
        const message =
        {
            notification: { body },
            token: messageToken,
            data: { recipient: body },
        };

        admin.messaging().send(message)
        .then(response =>
        {
            console.log("Successfully sent message", response);
        })
        .catch(error =>
        {
            console.log("Error sending message", error);
        })

    }
});
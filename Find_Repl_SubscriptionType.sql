-- https://ask.sqlservercentral.com/questions/112368/how-to-identitfy-pushpulll-method-of-replication-i.html

DECLARE @PublicationName sysname
 SET @PublicationName = 'COWS_PUB'
 
 SELECT  pub.name Publication,
         art.name Article,
         sub.srvname DestinationServer,
         sub.dest_db DestinationDatabase,
         CASE WHEN subscription_type = 1 THEN 'Pull' ELSE 'Push' END AS SubscriptionType
 FROM    dbo.syspublications AS pub
 INNER JOIN dbo.sysarticles AS art ON art.pubid = pub.pubid
 INNER JOIN dbo.syssubscriptions AS sub ON art.artid = sub.artid
 WHERE   pub.name = @PublicationName
-- Correct_LoginSIDs

USE [master]
GO

/****** Object:  Login [FEO_USER]    Script Date: 10/25/2019 1:20:41 PM ******/
DROP LOGIN [FEO_USER]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [FEO_USER]    Script Date: 10/25/2019 1:20:41 PM ******/
CREATE LOGIN [FEO_USER] WITH PASSWORD=N'JZ8gkma-', SID = 0xF7C47A45EFEDF640B613208C1B10862E, DEFAULT_DATABASE=[SSTAT], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

/****** Object:  Login [TRP_ORA_LINK]    Script Date: 10/25/2019 2:11:55 PM ******/
DROP LOGIN [TRP_ORA_LINK]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [TRP_ORA_LINK]    Script Date: 10/25/2019 2:11:55 PM ******/
CREATE LOGIN [TRP_ORA_LINK] WITH PASSWORD=N'I_tI3k8X', SID = 0x3DF6E2F043ED6246BFDC384622F79425, DEFAULT_DATABASE=[SSTAT], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

/****** Object:  Login [uap_admin_web]    Script Date: 10/25/2019 2:02:48 PM ******/
DROP LOGIN [uap_admin_web]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [uap_admin_web]    Script Date: 10/25/2019 2:02:48 PM ******/
CREATE LOGIN [uap_admin_web] WITH PASSWORD=N'1SZ3fJo_', SID = 0xB11D0872D8521C4EABEE52972A07256E, DEFAULT_DATABASE=[SSTAT], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

/****** Object:  Login [uap_trams_web]    Script Date: 10/25/2019 2:00:13 PM ******/
DROP LOGIN [uap_trams_web]
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [uap_trams_web]    Script Date: 10/25/2019 2:00:13 PM ******/
CREATE LOGIN [uap_trams_web] WITH PASSWORD=N'I2klG5l_', SID = 0xA98E9B5BD5B908489E2E1B2571AA34ED, DEFAULT_DATABASE=[SSTAT], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

/****** Object:  Login [uap_trs_gate_svc]    Script Date: 10/25/2019 2:16:19 PM ******/
DROP LOGIN [uap_trs_gate_svc]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [uap_trs_gate_svc]    Script Date: 10/25/2019 2:16:19 PM ******/
CREATE LOGIN [uap_trs_gate_svc] WITH PASSWORD=N'uR6Ar-gs', SID = 0xDDF9182358EAF7439BE754D5C88EBD74, DEFAULT_DATABASE=[SSTAT], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


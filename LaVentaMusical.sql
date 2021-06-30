create database LaVentaMusical
go

use LaVentaMusical
go

create table usuariosSistema
(
	idUsuario varchar(50) primary key not null,
	nombreUsuario varchar(100) not null,
	generoUsuario varchar(10) not null,
	correoElectUsuario varchar(200) not null,
	tipoTarjetaUsuario varchar(50) not null,
	tarjetaUsuario varchar(100) not null,
	claveUsuario varchar(50) not null,
	perfilUsuario varchar(10)
);

create table generosMusicales
(
	codGenero varchar(50) primary key not null,
	descGenero varchar(100) not null
);

create table canciones
(
	codCancion varchar(50) primary key not null,
	nombreCancion varchar(100) not null,
	codGenero varchar(50) not null,
	precioCancion decimal(10,2) not null
);

create table compraCabecera
(
	numFact varchar(10) primary key not null,
	fechaCompra date not null,
	idUsuario varchar(50) not null,
	totalFact decimal(10,2) not null
);

create table compraDetalle
(
	numFact varchar(10) not null,
	codCancion varchar(50) not null
);

go

CREATE PROCEDURE ingresarUsuario 
	@idUsuario varchar(50),
	@nombreUsuario varchar(100),
	@generoUsuario varchar(10),
	@correoElectUsuario varchar(200),
	@tipoTarjetaUsuario varchar(50),
	@tarjetaUsuario varchar(100),
	@claveUsuario varchar(50),
	@perfilUsuario varchar(10)
AS
BEGIN
	INSERT INTO usuariosSistema
	(idUsuario,	nombreUsuario, generoUsuario, correoElectUsuario, tipoTarjetaUsuario, tarjetaUsuario, claveUsuario, perfilUsuario) 
	VALUES
	(@idUsuario, @nombreUsuario, @generoUsuario, @correoElectUsuario, @tipoTarjetaUsuario, @tarjetaUsuario, @claveUsuario, @perfilUsuario)
END
GO

CREATE PROCEDURE actualizarUsuario 
	@idUsuario varchar(50),
	@nombreUsuario varchar(100),
	@generoUsuario varchar(10),
	@correoElectUsuario varchar(200),
	@tipoTarjetaUsuario varchar(50),
	@tarjetaUsuario varchar(100),
	@claveUsuario varchar(50),
	@perfilUsuario varchar(10)
AS
BEGIN
	UPDATE usuariosSistema SET
	nombreUsuario = @nombreUsuario, 
	generoUsuario = @generoUsuario, 
	correoElectUsuario = @correoElectUsuario, 
	tipoTarjetaUsuario = @tipoTarjetaUsuario, 
	tarjetaUsuario = @tarjetaUsuario, 
	claveUsuario = @claveUsuario, 
	perfilUsuario = @perfilUsuario
	WHERE idUsuario = @idUsuario
END
GO

CREATE PROCEDURE ingresarGenerosMusicales
	@codGenero varchar(50),
	@descGenero varchar(100)
AS
BEGIN
	INSERT INTO generosMusicales
	(codGenero,	descGenero) 
	VALUES
	(@codGenero, @descGenero)
END
GO

CREATE PROCEDURE actualizarGenerosMusicales 
	@codGenero varchar(50),
	@descGenero varchar(100)
AS
BEGIN
	UPDATE generosMusicales SET
	descGenero = @descGenero
	WHERE codGenero = @codGenero
END
GO

CREATE PROCEDURE ingresarCanciones
	@codCancion varchar(50),
	@nombreCancion varchar(100),
	@codGenero varchar(50),
	@precioCancion decimal(10,2)
AS
BEGIN
	INSERT INTO canciones
	(codCancion, nombreCancion, codGenero, precioCancion) 
	VALUES
	(@codCancion, @nombreCancion, @codGenero, @precioCancion)
END
GO

CREATE PROCEDURE actualizarCanciones 
	@codCancion varchar(50),
	@nombreCancion varchar(100),
	@codGenero varchar(50),
	@precioCancion decimal(10,2)
AS
BEGIN
	UPDATE canciones SET
	nombreCancion = @nombreCancion,
	codGenero = @codGenero,
	precioCancion = @precioCancion
	WHERE codCancion = @codCancion
END
GO

CREATE PROCEDURE ingresarCompraCabecera
	@numFact varchar(10),
	@fechaCompra date,
	@idUsuario varchar(50),
	@totalFact decimal(10,2)
AS
BEGIN
	INSERT INTO compraCabecera
	(numFact, fechaCompra, idUsuario, totalFact) 
	VALUES
	(@numFact, @fechaCompra, @idUsuario, @totalFact)
END
GO

CREATE PROCEDURE ingresarCompraDetalle
	@numFact varchar(10),
	@codCancion varchar(50)
AS
BEGIN
	INSERT INTO compraDetalle
	(numFact, codCancion) 
	VALUES
	(@numFact, @codCancion)
END
GO

CREATE PROCEDURE loginUsuario 
	@idUsuario varchar(50),
	@claveUsuario varchar(50)
AS
BEGIN
	SELECT 
		idUsuario,
		nombreUsuario,
		perfilUsuario,
		tarjetaUsuario
	FROM usuariosSistema
	where idUsuario = @idUsuario and claveUsuario = @claveUsuario
END
GO

CREATE PROCEDURE consultarUsuario 
	@idUsuario varchar(50)
AS
BEGIN
	SELECT 
		idUsuario,	
		nombreUsuario, 
		generoUsuario, 
		correoElectUsuario, 
		tipoTarjetaUsuario, 
		tarjetaUsuario, 
		claveUsuario, 
		perfilUsuario
	FROM usuariosSistema
	where idUsuario = @idUsuario
END
GO

CREATE PROCEDURE consultarGenerosMusicales
AS
BEGIN
	SELECT 
		codGenero,	
		descGenero
	FROM generosMusicales
	
END
GO

CREATE PROCEDURE consultarCanciones
AS
BEGIN
	SELECT 
		codCancion, 
		nombreCancion, 
		codGenero,
		precioCancion 
	FROM canciones
END
GO

CREATE PROCEDURE repUsuariosSistema
AS
BEGIN
	SELECT 
		idUsuario,	
		nombreUsuario, 
		generoUsuario, 
		correoElectUsuario, 
		tipoTarjetaUsuario, 
		tarjetaUsuario, 
		claveUsuario, 
		perfilUsuario
	FROM usuariosSistema
END
GO

CREATE PROCEDURE repFacturasRealizadas
AS
BEGIN
	SELECT 
		a.numFact, 
		a.fechaCompra, 
		a.idUsuario, 
		a.totalFact,
		b.codCancion,
		c.nombreCancion
	FROM compraCabecera a
	INNER JOIN compraDetalle b
		on a.numFact = b.numFact
	INNER JOIN canciones c
		on b.codCancion = c.codCancion
END
GO

CREATE PROCEDURE repCantidadCanciones
AS
BEGIN
	SELECT 
		count(a.codCancion) cantidadCancion,
		b.nombreCancion,
		c.descGenero
	FROM compraDetalle a
	INNER JOIN canciones b
		on a.codCancion = b.codCancion
	INNER JOIN generosMusicales c
		on b.codGenero = c.codGenero
	GROUP BY b.nombreCancion, c.descGenero
END
GO
CREATE  DATABASE  Juegos;
USE Juegos;

CREATE TABLE  Partida (
	IdPartida INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Pista VARCHAR(40),
	Vueltas SMALLINT,
	TipoPartida TINYINT
);

CREATE TABLE  Jugador (
	IdJugador INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Nickname VARCHAR(15),
	Tiempo TIME,
	Posicion TINYINT,
	IdPartida INT,
	VueltasRealizadas SMALLINT,
	FOREIGN KEY (IdPartida) REFERENCES Partida(IdPartida)
);

-------------------------------------------- Procedures ----------------------------------------------------
--Crear una nueva partida
GO
CREATE PROCEDURE proceCrearPartida (@pPista VARCHAR(40),@pVueltas SMALLINT,@pTipoPartida TINYINT,@pId INT OUTPUT)
AS
	INSERT INTO Partida (
			Pista,
			Vueltas,
			TipoPartida)
			VALUES (
			@pPista,
			@pVueltas,
			@pTipoPartida);
	SELECT @pId =  SCOPE_IDENTITY()
	RETURN @pId
;

EXECUTE proceCrearPartida 'Pista7.txt',2,2,0;



--Crear estadistico de juego
GO
CREATE PROCEDURE proceEstadisticoJugadores
AS
	SELECT 
		JUGA.Posicion,
		CONVERT(varchar,JUGA.Tiempo,8) As Tiempo,
		JUGA.Nickname,
		PART.Pista,
		PART.IdPartida,
		PART.TipoPartida
	FROM Jugador JUGA 
	INNER JOIN Partida PART ON PART.IdPartida = JUGA.IdPartida
	GROUP BY PART.IdPartida, JUGA.Nickname,JUGA.Posicion, PART.Pista,PART.TipoPartida,JUGA.Tiempo
	ORDER BY JUGA.Posicion ASC,JUGA.Tiempo ASC, JUGA.Nickname ASC
;

--Crear ranking de juego
GO
CREATE PROCEDURE proceRanking
AS
	SELECT 
		JUGA.Nickname,
		CONVERT(varchar,JUGA.Tiempo,8) As Tiempo,
		PART.Pista,
		PART.Vueltas,
		PART.IdPartida,
		PART.TipoPartida
	FROM Jugador JUGA 
	INNER JOIN Partida PART ON PART.IdPartida = JUGA.IdPartida
	WHERE JUGA.Posicion = 1				
	ORDER BY PART.IdPartida ASC
;

--Crear un jugador
GO
CREATE PROCEDURE proceCrearJugador (@pNickname VARCHAR(15),@pTiempo TIME, @pPosicion TINYINT, @pIdPartida INT, @pVueltasRealizadas SMALLINT)
AS
	INSERT INTO Jugador(
			Nickname,
			Tiempo,
			Posicion,
			IdPartida,
			VueltasRealizadas)
			VALUES (
			@pNickname,
			@pTiempo, 
			@pPosicion, 
			@pIdPartida, 
			@pVueltasRealizadas);
;


--Modificar vueltas realizadas
GO
CREATE PROCEDURE proceModificarVueltasRealizadas(@pVueltas SMALLINT, @pNickname VARCHAR(15))
AS
	IF EXISTS (SELECT * FROM Juegos.dbo.Jugador WHERE Nickname = @pNickname)
	BEGIN
		UPDATE Juegos.dbo.Jugador SET VueltasRealizadas = @pVueltas WHERE Jugador.Nickname = @pNickname;
	END
;

--Modificar posicion de jugador
GO
CREATE PROCEDURE proceModificarPosicionJugador(@pPosicion TINYINT, @pNickname VARCHAR(15))
AS
	IF EXISTS (SELECT * FROM Juegos.dbo.Jugador WHERE Nickname = @pNickname)
	BEGIN
		UPDATE Juegos.dbo.Jugador SET Posicion = @pPosicion WHERE Jugador.Nickname = @pNickname;
	END
;





--PRUEBAS
EXECUTE proceCrearPartida  'Pista1.txt',2,2,0;
EXECUTE proceCrearPartida  'Pista2.txt',1,1,0;

EXECUTE proceCrearPartida 'Pista7.txt',2,2,0;
EXECUTE proceCrearPartida 'Pista12.txt',5,1,0;

EXECUTE proceCrearJugador 'Felipe','00:04:20',2,1,1;
EXECUTE proceCrearJugador 'Marcos','00:04:50',1,1,3;
EXECUTE proceCrearJugador 'Antonio','00:04:50',4,2,2;
EXECUTE proceCrearJugador 'Fernanda','00:03:00',1,2,1;
EXECUTE proceEstadisticoJugadores;
EXECUTE proceRanking;

Select * from Partida;
Select * from Jugador;


EXECUTE proceCrearJugador 'Pepe','00:07:10',3,4,4
EXECUTE proceModificarVueltasRealizadas 5,'Felipe'
EXECUTE proceModificarPosicionJugador 3,'Antonio'
EXECUTE proceModificarPosicionJugador 3,'Carlos'


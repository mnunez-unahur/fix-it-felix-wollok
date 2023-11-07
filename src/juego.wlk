import wollok.game.*
import ralph.*
import animacion.*
import elementos.*
import felix.*
import pantalla.*
import personaje.*

object juego {
//	var gameOver = false
	const stages = []
	var stage = 0
	
	var property vidas = 3
	var iniciado  = false
	
	method stageActual() = stages.get(stage)
	method tableroActual() = self.stageActual().tablero()

	method iniciar() {
		self.configurarVisual()
		self.configurarStages()
		self.mostrarImagenesIniciales()
		self.configurarSonido()
		game.start()
	}
	
	method configurarSonido(){
		var  sound = game.sound("Sonidos/juego2.mp3")
		sound.shouldLoop(true)
		game.schedule(500, { sound.play()} )
		keyboard.enter().onPressDo({sound.stop()})
	}

	method configurarVisual(){
		game.title("Fix It Felix Jr!")
		game.width(100)
		game.height(60)
		game.cellSize(10)
	  	game.boardGround("fondo.png")
		vida.addVisual()
		
		// pongo un par de nubes
		const nube1 = new Nube(position = new Position(x=-20, y=40))
		nube1.addVisual()
		nube1.mover()
		
		const nube2 = new Nube(position = new Position(x=-20, y=20), velocidad=10)
		nube2.addVisual()
		nube2.mover()			
		
		score.addVisual()
	}
	
	method configurarStages() {
		// stage 1
		const stage1 = new Stage(
			dificultad = 1,
			fondo = new Edificio(image="niveles/edificio-1.png"), 
			imgInicial = new Pantalla (image ="fondo/stage1.jpg"))
		
		stage1.agregarMultiplesVentanas(1, [
			[1,1],[2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [4,3], [5,3]
		])
		stage1.agregarMultiplesVentanas(2, [
			[3,3]
		])
		
		stage1.agregarMultiplesMacetas([
			[4,3],[1,2]
		])
		stage1.agregarMultiplesPostigos([
			[4,1],[1,3]
		])
		
		// stage 2
		const stage2 = new Stage(
			dificultad = 2,
			fondo = new Edificio(image="niveles/edificio-2.png"),
			imgInicial = new Pantalla (image = "fondo/stage2.jpg")
		)
		stage2.agregarMultiplesVentanas(1, [
			[1,1], [2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [4,3], [5,3]
		])
		stage2.agregarMultiplesVentanas(2, [
			[3,1],[3,2],[3,3]
		])

		stage2.agregarMultiplesMacetas([
			[2,2], [3,2],[4,2]		
		])
		stage2.agregarMultiplesPostigos([
			[1,2],[4,3]
		])

		// stage 3
		const stage3 = new Stage(
			dificultad = 3,
			fondo = new Edificio(image="niveles/edificio-2.png"),
			imgInicial = new Pantalla (image = "fondo/stage3.jpg")
		)
		stage3.agregarMultiplesVentanas(1, [
			[1,1], [2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [4,3], [5,3]
		])
		stage3.agregarMultiplesVentanas(2, [
			[3,1],
			[3,2],
			[3,3]
		])
		stage3.agregarMultiplesMacetas([
			[2,2], [4,2],
			[1,3], [5,3]
		])
		stage3.agregarMultiplesPostigos([
			[1,1],[3,3], [5,2]
		])

		// stage 4
		const stage4 = new Stage(
			dificultad = 4,
			fondo = new Edificio(image="niveles/edificio-2.png"),
			imgInicial = new Pantalla (image = "fondo/stage4.jpg")
		)
		stage4.agregarMultiplesVentanas(1, [
			[1,1], [2,1], [4,1], [5,1],
			[1,2], [2,2], [4,2], [5,2],
			[1,3], [2,3], [4,3], [5,3]
		])
		stage4.agregarMultiplesVentanas(2, [
			[3,1],
			[3,2],
			[3,3]
		])
		stage4.agregarMultiplesMacetas([
			[3,2], [4,2]
		])
		stage4.agregarMultiplesPostigos([
			[1,1],[1,2], [3,2],[4,3]
		])

		// stage 5
		const stage5 = new Stage(
			dificultad = 5,
			fondo = new Edificio(image="niveles/edificio-2.png"),
			imgInicial = new Pantalla (image = "fondo/stage5.jpg")
		)
		stage5.agregarMultiplesVentanas(2, [
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
		stage5.agregarMultiplesMacetas([
			[1,2],[2,2]

		])
		stage5.agregarMultiplesPostigos([
			[1,3],[4,3],[3,2],[5,1]
		])
		
		// stage 6
			const stage6 = new Stage(
			dificultad = 6,
			fondo = new Edificio(image="niveles/edificio-3.png"),
			imgInicial = new Pantalla (image = "fondo/stage6.jpg")
		)
		stage6.agregarMultiplesVentanas(1,[
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
		stage6.agregarMultiplesMacetas([
			[1,2],[2,2],[5,3],[2,3]

		])
		stage6.agregarMultiplesPostigos([
			[3,2],[4,1]
		])
		// stage 7
			const stage7 = new Stage(
			dificultad = 7,
			fondo = new Edificio(image="niveles/edificio-3.png"),
			imgInicial = new Pantalla (image = "fondo/stage7.jpg")
		)
		stage7.agregarMultiplesVentanas(2,[
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
		stage7.agregarMultiplesMacetas([
			[3,2], [4,2]

		])
		stage7.agregarMultiplesPostigos([
			[1,1],[1,3], [3,2],[4,3]
		])
		
		// stage 8
		const stage8 = new Stage(
			dificultad = 8,
			fondo = new Edificio(image="niveles/edificio-3.png"),
			imgInicial = new Pantalla (image = "fondo/stage8.jpg")
		)
		stage8.agregarMultiplesVentanas(1,[
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
		stage8.agregarMultiplesMacetas([
			[4,3],[1,2]
		])
		stage8.agregarMultiplesPostigos([
			[1,3],[3,2],[5,1]
		])
			// stage 9
			const stage9 = new Stage(
			dificultad = 9,
			fondo = new Edificio(image="niveles/edificio-3.png"),
			imgInicial = new Pantalla (image = "fondo/stage9.jpg")
		)
		stage9.agregarMultiplesVentanas(2,[
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])
		stage9.agregarMultiplesMacetas([
			[1,2],[2,2]

		])
		stage9.agregarMultiplesPostigos([
			[1,3],[4,3],[3,2],[5,1]
		])	
			// stage 10
			const stage10 = new Stage(
			dificultad = 10,
			fondo = new Edificio(image="niveles/edificio-3.png"),
			imgInicial = new Pantalla (image = "fondo/stage10.jpg"),
			turboTastic=true
			
		)
		stage10.agregarMultiplesVentanas(2,[
			[1,1], [2,1], [3,1], [4,1], [5,1],
			[1,2], [2,2], [3,2], [4,2], [5,2],
			[1,3], [2,3], [3,3], [4,3], [5,3]
		])

		

		self.agregarStage(stage1)
		self.agregarStage(stage2)
		self.agregarStage(stage3)
		self.agregarStage(stage4)
		self.agregarStage(stage5)
		self.agregarStage(stage6)
		self.agregarStage(stage7)
		self.agregarStage(stage8)
		self.agregarStage(stage9)
		self.agregarStage(stage10)
		
	}
		
	
	method agregarStage(nuevoStage) {
		stages.add(nuevoStage)
	}
	
	method mostrarImagenesIniciales(){
		const inicio = new Pantalla(image = "fondo/inicioJuego.JPG",incluirScore = false)
		inicio.addVisual()
		keyboard.enter().onPressDo({
			if(!iniciado){
				inicio.removeVisual();
			   	self.stageActual().iniciar()
			   	iniciado = true
		   	}
	   	})						
	}
	
	method siguienteNivel() {
		self.stageActual().finalizar()
		self.configurarVisual()
		stage++
		if(stage < stages.size()){
			vida.ganarVida()
			self.stageActual().iniciar()
		}else{
			congrats.addVisual()
			new Sonido (sound = "Sonidos/winGame.mp3").reproducir()
		}
		//TODO: cuando se finaliza el ultimo nivel se termina el juego	
	}
}

// representa una celda del tablero
// cada celda puede contener o no ventana
class Celda{
	var ventana = null
	const obstaculos = []
	const property position
	const property posicionRelativa
	
	
	method ventana() = ventana
	method obstaculos() = obstaculos
	
	method agregarVentana(modelo) {
		ventana = new Ventana(position = position, modelo=modelo)
	}
	
	method agregarPostigo() {
		obstaculos.add(new Postigo(position = position))
	}

	method agregarMaceta() {
		obstaculos.add(new Maceta(position = position))
	}
	
	method tieneVentana() = ventana != null
	method tieneObstaculos() = obstaculos.size() > 0
	method tieneVentanaReparable() {
		return self.tieneVentana() && ventana.salud() < 2
	}
	method tieneObstaculoALaIzquierda(){
		return self.tieneObstaculos() &&
			   obstaculos.any(	{o => o.izquierda()}	)
	}
	method tieneObstaculoALaDerecha(){
		return self.tieneObstaculos() &&
			   obstaculos.any(	{o => o.derecha()}	)
	}
	method tieneObstaculoAbajo(){
		return self.tieneObstaculos() &&
			   obstaculos.any(	{o => o.abajo()}	)
	}
	
	
}

class Tablero {
	// la grilla representa las posisiones válidas del tablero
	const grilla = [
		new Celda(position = new Position(x = 30, y = 2), posicionRelativa = new Position(x=1, y=1)),
		new Celda(position = new Position(x = 39, y = 2), posicionRelativa = new Position(x=2, y=1)),
		new Celda(position = new Position(x = 48, y = 2), posicionRelativa = new Position(x=3, y=1)),
		new Celda(position = new Position(x = 57, y = 2), posicionRelativa = new Position(x=4, y=1)),
		new Celda(position = new Position(x = 66, y = 2), posicionRelativa = new Position(x=5, y=1)),
		new Celda(position = new Position(x = 30, y = 16), posicionRelativa = new Position(x=1, y=2)),
		new Celda(position = new Position(x = 39, y = 16), posicionRelativa = new Position(x=2, y=2)),
		new Celda(position = new Position(x = 48, y = 16), posicionRelativa = new Position(x=3, y=2)),
		new Celda(position = new Position(x = 57, y = 16), posicionRelativa = new Position(x=4, y=2)),
		new Celda(position = new Position(x = 66, y = 16), posicionRelativa = new Position(x=5, y=2)),
		new Celda(position = new Position(x = 30, y = 32), posicionRelativa = new Position(x=1, y=3)),
		new Celda(position = new Position(x = 39, y = 32), posicionRelativa = new Position(x=2, y=3)),
		new Celda(position = new Position(x = 48, y = 32), posicionRelativa = new Position(x=3, y=3)),
		new Celda(position = new Position(x = 57, y = 32), posicionRelativa = new Position(x=4, y=3)),
		new Celda(position = new Position(x = 66, y = 32), posicionRelativa = new Position(x=5, y=3))
	]
	
	var property celdaActiva = grilla.get(0)
	
	// cantidad de filas y de columnas del tablero
	// se ponen como constantes para evitar ejecutar la misma búsqueda a cada rato
	const cantidadFilas = grilla.map({c => c.posicionRelativa().y()}).max()
	const cantidadColumnas = grilla.map({c => c.posicionRelativa().x()}).max()
	
	
	method esCoordinadaValida(x, y) {
		return grilla.any({c => c.posicionRelativa().x() == x && c.posicionRelativa().y() == y})
	}
	
	// dada una coordenada válida del tablero, devuelve la celda de dicha coordenada
	// x e y son las posiciones relativas de la celda
	method celda(x, y) {
		if(!self.esCoordinadaValida(x, y)) {
			self.error("las coordenadas quedan fuera del tablero")
		}
		return grilla.find({c => c.posicionRelativa().x() == x && c.posicionRelativa().y() == y})
	}
	
	
	method celdasConVentanas() = grilla.filter({c => c.tieneVentana()})

	method celdasConObstaculos() = grilla.filter({c => c.tieneObstaculos()})
	
	// devuelve la lista de ventanas del tablero
	method ventanas() {
		return self.celdasConVentanas().map({v => v.ventana()})		
	}
	
	method obstaculos() {
		return self.celdasConObstaculos().map({v => v.obstaculos()}).flatten()		
	}
	
	
	method cantidadVentanasRotas() {
		return self.ventanas().count({v => v.salud() < 2})
	}
	
	method mostrarVentanas() {
		self.ventanas().forEach({v => v.addVisual()})		
	}
	
	//Oculta las ventanas del stage si están visibles
	method ocultarVentanas() {
		self.ventanas().forEach({v => v.removeVisual()})		
	}
	
	method mostrarObstaculos() {
		self.obstaculos().forEach({v => v.addVisual()})		
	}

	//muestra los componentes del tablero
	method mostrar() {
		self.mostrarVentanas()
	}
	
	// devuelve la celda correspondiente a la posición absoluta indicada
	method celdaEn(position) {
		return grilla.find({c => c.position() == position})
	}
	
	
	method esPrimeraColumna(celda) {
		return celda.posicionRelativa().x() == 1
	}

	method esPrimeraFila(celda) {
		return celda.posicionRelativa().y() == 1
	}

	method esUltimaColumna(celda) {
		return celda.posicionRelativa().x() == cantidadColumnas
	}

	method esUltimaFila(celda) {
		return celda.posicionRelativa().y() == cantidadFilas
	}
	method puedeMoverALaIzquierda(){
		return  self.hayCeldaALaIzquierda() &&  
			   !self.celdaActiva().tieneObstaculoALaIzquierda()	&&
			   !self.celdaALaIzquierda().tieneObstaculoALaDerecha()
			
	}
	method puedeMoverALaDerecha(){
		return  self.hayCeldaALaDerecha()&&  
			   !self.celdaActiva().tieneObstaculoALaDerecha()&&
			   !self.celdaALaDerecha().tieneObstaculoALaIzquierda()
	}
	
	method puedeMoverArriba(){
		return  self.hayCeldaArriba()&&
			   !self.celdaArriba().tieneObstaculoAbajo()
	}
	
	
	method puedeMoverAbajo(){
		return self.hayCeldaAbajo() &&  
			   !self.celdaActiva().tieneObstaculoAbajo()
	}
	
	method hayCeldaALaIzquierda(){
		return !self.esPrimeraColumna(self.celdaActiva())
	}
	method hayCeldaALaDerecha(){
		return !self.esUltimaColumna(self.celdaActiva())
	}
	method hayCeldaArriba(){
		return !self.esUltimaFila(self.celdaActiva())
	}
	method hayCeldaAbajo(){
		return !self.esPrimeraFila(self.celdaActiva())
	}
	
	method celdaALaIzquierda(){
		if(!self.hayCeldaALaIzquierda()){
			self.error("No hay celda a la izquierda")
		}
		return grilla.find({c => c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x() - 1
							&&   c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y()
		})
	}
	method celdaALaDerecha(){
		if(!self.hayCeldaALaDerecha()){
			self.error("No hay celda a la Derecha")
		}
		return grilla.find({c => c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x() + 1
							&&   c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y()
		})
	}
	method celdaArriba(){
		if(!self.hayCeldaArriba()){
			self.error("No hay celda a la Arriba")
		}
		return grilla.find({c => c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y() + 1
							&&   c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x()
		})
	}
	method celdaAbajo(){
		if(!self.hayCeldaAbajo()){
			self.error("No hay celda a la Abajo")
		}
		return grilla.find({c => c.posicionRelativa().y() == self.celdaActiva().posicionRelativa().y() - 1
							&&   c.posicionRelativa().x() == self.celdaActiva().posicionRelativa().x()
		})
	}
	
	
	// devuelve la celda a la izquierda de la actual
	// si la celda actual es la primera, la devuelve
	method left() {
		if(self.puedeMoverALaIzquierda()) {
			return self.celdaALaIzquierda()
		} else {
			return self.celdaActiva()
		}
	}

	// devuelve la celda a la derecha de la actual
	// si la celda actual es la ultima, la devuelve
	method right() {
		if(self.puedeMoverALaDerecha()) {
			return self.celdaALaDerecha()
		} else {
			return self.celdaActiva()
		}
	}

	// devuelve la celda que esta arriba de la actual
	// si la celda actual es la ultima, la devuelve
	method up() {
		if(self.puedeMoverArriba()) {
			return self.celdaArriba()
		} else {
			return self.celdaActiva()
		}
	}

	// devuelve la celda que esta abajo de la actual
	// si la celda actual es la primera, la devuelve
	method down() {
		if(self.puedeMoverAbajo()) {
			return self.celdaAbajo()
		} else {
			return self.celdaActiva()
		}
	}

	
}

class Stage {
	const fondo
	const imgInicial
	const property dificultad
	const turboTastic = false
	
	const tablero = new Tablero()
	method celdaActiva() = tablero.celdaActiva()
	
	method tablero() = tablero
	
	// agrega una ventana en la celda x y del tablero
	method agregarVentanaEn(modelo, x,y) {
		tablero.celda(x, y).agregarVentana(modelo)	
	}
	
	method configurarTeclas() {
		keyboard.x().onPressDo({ self.repararVentanaSiHay()	})
		keyboard.space().onPressDo({ self.repararVentanaSiHay()	})
		
		keyboard.right().onPressDo({
			if(!felix.saltando()) {
				felix.moverAPosicionyHacerAccion(tablero.right().position().x(),felix.coordenadaActualY(), {
					tablero.celdaActiva(tablero.celdaEn(felix.position()))
				})
			}
		})
		keyboard.left().onPressDo({
			if(!felix.saltando()) {
				felix.moverAPosicionyHacerAccion(tablero.left().position().x(),felix.coordenadaActualY(),{
					tablero.celdaActiva(tablero.celdaEn(felix.position()))
				} )	
			}
		})
		
		keyboard.up().onPressDo({
			if(!felix.saltando()) {
				felix.moverAPosicionyHacerAccion(felix.coordenadaActualX(), tablero.up().position().y(), {
					tablero.celdaActiva(tablero.celdaEn(felix.position()))
				})
			}
		})
		
		keyboard.down().onPressDo({
			if(!felix.saltando()) {
				felix.moverAPosicionyHacerAccion(felix.coordenadaActualX(), tablero.down().position().y(), {
					tablero.celdaActiva(tablero.celdaEn(felix.position()))
				})
			}
		})	
		
	}	

	method repararVentanaSiHay() {
		if(!felix.saltando() && !felix.reparando() && self.celdaActiva().tieneVentana()) {
			felix.reparar(self.celdaActiva().ventana());
			
			
			// espero a que la ventana esté reparada
			// esto es porque por un tema de animación felix tarda 200 ms en reparar la ventana
			game.schedule(300,{
				if(tablero.cantidadVentanasRotas() == 0) {
					juego.siguienteNivel()
				}			
			})	  			
			
		}
	}
	
	
	method mostrar(){ 
		game.addVisual(fondo)
		ralph.addVisual()
	  	tablero.mostrar()
	  	felix.addVisual()
	  	tablero.mostrarObstaculos()
	  	
	  	
	}
	
	method ocultar() {
		felix.removeVisual()
		game.removeVisual(fondo)
		ralph.removeVisual()
		
	}
	
	
	// agrega múltiples ventanas en las coordinadas indicadas
	// lista es una lista de coordenadas [[x,y], [x,y]...]
	method agregarMultiplesVentanas(modelo, lista) {
		lista.forEach({ c => self.agregarVentanaEn(modelo, c.get(0), c.get(1))})
	}

	method agregarMultiplesMacetas(lista) {
		lista.forEach({ c => tablero.celda(c.get(0), c.get(1)).agregarMaceta()})
	}

	method agregarMultiplesPostigos(lista) {
		lista.forEach({ c => tablero.celda(c.get(0), c.get(1)).agregarPostigo()})
	}

	method iniciar() {
	  	self.mostrar()
	  	imgInicial.mostrarPorMilisegundosYLuegoEjecutar(2000, {
			self.configurarTeclas()
			felix.stage(self)
			ralph.stage(self)
			ralph.hacerRutina()
			if(turboTastic) {
				turbo.aparecer()				
			}
	  	})
	}
	
	
	
	method finalizar() {
		ralph.reset()		
//		felix.position(tablero.celda(1,1).position())
		felix.reset()
		self.ocultar()
		game.clear()
	}
	
}

//representa un stage nulo
// se utiliza para inicializar los personajes que tienen un atributo stage
object nullStage inherits Stage(
			dificultad = 0,
			fondo = new Edificio(image="niveles/edificio-1.png"), 
			imgInicial = new Pantalla (image ="nada.jpg")){
	override method mostrar() {}
	override method ocultar() {}
}


// Score
object score inherits Visual(position = new Position(x=2, y=56)) { 
	var property puntaje = 0
	const digitos = [
		new Digito(position = new Position(x= 23, y=56)),
		new Digito(position = new Position(x= 21, y=56)),
		new Digito(position = new Position(x= 19, y=56)),
		new Digito(position = new Position(x= 17, y=56)),
		new Digito(position = new Position(x= 15, y=56)),
		new Digito(position = new Position(x= 13, y=56))
	]
	
	override method addVisual() {
		super()
		digitos.forEach({d => d.addVisual()})
	}
	
	override method removeVisual() {
		super()
		digitos.forEach({d => d.removeVisual()})
	}
	override method image()="score.png"
	
	method puntaje(nuevoPuntaje) {
		puntaje = nuevoPuntaje
		var p = nuevoPuntaje
		
		(0..5).forEach({ i => 
			const d = (p % 10).truncate(0)
			digitos.get(i).valor(d)
			p = (p / 10).truncate(0);
		})
		
	}
	
	method sumarPuntos(puntos) {
		self.puntaje(puntaje + puntos)
	}
	
	method reset() {
		puntaje = 0
	}
}


// representa un digito del 0 al 9 en la pantalla
class Digito inherits Visual {
	var property valor = 0
	
	override method image() = "numeros/" + valor + ".png" 
}

object vida inherits Visual (position=new Position(y=55, x=80 )){ 
	var property vidasActuales = 3
	
	override method image(){
		if (vidasActuales == 3){
			return "fondo/vida3.png"
		}else if (vidasActuales ==2 ){
			return "fondo/vida2.png"
		}else if (vidasActuales ==1){
			return "fondo/vida1.png"
		}else{
			return "fondo/sin vida.png"
		}
	}
	
	method perderVida(){
		vidasActuales = 0.max(vidasActuales-1)
	}
	method ganarVida(){
		vidasActuales = 3.min(vidasActuales+1)
	}
}







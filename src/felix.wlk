import animacion.*
import elementos.*
import personaje.*
import juego.*
import pantalla.*
import wollok.game.*


object felix inherits Animado( velocidad = 30 ){
	
	var mirandoAlaDerecha = true
	var saltando = false
	var reparando = false
	
	//mientras felix está inmune los objetos no le hacen daño
	var inmune = false
	const sensoresVerticales = []
	const sensoresHorizontales = []
	
	//referencia al stage actual
	var property stage = nullStage
	
	var invisible = false
	

	const  animacionParadoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=0,
  										fotogramas=["felix/derecha-parado.png"])
 
  
	const  animacionReparandoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=6,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png", 
  													"felix/derecha-golpeando.png",
  													"felix/derecha-parado.png"]
  								)
    const  animacionReparandoIzquierda = new Animacion( 
				  						velocidad=6,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png", 
  													"felix/izquierda-golpeando.png",
  													"felix/izquierda-parado.png"]
  								)  

	const  animacionSaltandoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png" 
  													]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png" 
  													]
  								)

  	const  animacionCayendoDerecha = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/derecha-saltando-1.png",
  													"felix/derecha-parado.png"
  													]
  								)

  	const  animacionCayendoIzquierda = new Animacion( 
				  						velocidad=4,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/izquierda-saltando-1.png",
  													"felix/izquierda-parado.png"
  													]
  								)


	method initialize() {
		animacion = animacionParadoDerecha
		self.agregarSensores()
		self.reset()
	}
	

	override method image() {
		return if(invisible) "nada.png" else super()
	}

	method dificultad() = stage.dificultad()

	// la velocidad de felix depende el nivel
	override method velocidad() {
		return super() + self.dificultad() * 2
	}

	method saltando() = saltando
	method reparando() = reparando
  								
  	method reparar(ventana){
  		if(!saltando && !reparando) {
  			reparando = true
	  		self.detenerMovimiento()
			self.animar(self.animacionReparando())
			game.schedule(200,{
				if(ventana.salud() < 2) {
					score.sumarPuntos(50)				
				}
				ventana.reparar()
				reparando = false
				self.siguienteFotograma()
			})	 
			arreglar.reproducir() 			
  		}
  	}
  	
  	method animacionReparando() {
  		return if(mirandoAlaDerecha) animacionReparandoDerecha else animacionReparandoIzquierda
  	}
  	
  	method animacionSaltando() {
  		return if(mirandoAlaDerecha) animacionSaltandoDerecha else animacionSaltandoIzquierda
  	}
  	method animacionCayendo() {
  		return if(mirandoAlaDerecha) animacionCayendoDerecha else animacionCayendoIzquierda
  	}
  	
  	override method addVisual() {
  		super()
		game.whenCollideDo(self, { c => if(c.haceDanio()) self.perderVida()  }) 
		self.mostrarSensores()
		self.activarSensores()
  	}
  	
  	override method removeVisual() {
  		super()
  		self.ocultarSensores()
  	}

	method agregarSensores() {
		const x = self.position().x()
		const y = self.position().y()
		(1..4).forEach({ i => self.agregarSensorVertical(x, y+i*2) })		
		(1..3).forEach({ i => self.agregarSensorHorizontal(x+i, y) })		
	}

	/* agrega un nuevo sensor vertical a felix */
	method agregarSensorVertical(x, y) {
		const sensor = new Sensor()
		sensor.positionXY(x, y)
		sensoresVerticales.add(sensor)			
	}

	/* agrega un nuevo sensor horizontal a felix */
	method agregarSensorHorizontal(x, y) {
		const sensor = new Sensor()
		sensor.positionXY(x, y)
		sensoresHorizontales.add(sensor)			
	}
  	
  	method mostrarSensores() {
		sensoresVerticales.forEach({s => s.addVisual()})
		sensoresHorizontales.forEach({s => s.addVisual()})
  	}
  	method activarSensores() {
		sensoresVerticales.forEach({s => s.activarDeteccion({ c => if(c.haceDanio()) self.perderVida()  })})
		sensoresHorizontales.forEach({s => s.activarDeteccion({ c => if(c.haceDanio()) self.perderVida()  })})
  	}
  	
  	method ocultarSensores() {
		sensoresVerticales.forEach({s => s.removeVisual()})  		
		sensoresHorizontales.forEach({s => s.removeVisual()})  		
  	}

	method actualizarSensores() {
		const x = self.position().x()
		const y = self.position().y()
		var i = 1
		sensoresVerticales.forEach({s => s.positionXY(x, y+i*2); i++})
		
		i = 1
		sensoresHorizontales.forEach({s => s.positionXY(x+i, y); i++})
	}

  	
  	
	method perderVida() {
  		if(!inmune) {
	  		inmune = true
	  		self.perderVida2()
	  		self.parpadear()
	  		game.schedule(3000, {
	  			inmune = false
				self.resetearAnimacion()		
	  		})
	  	
  	}}
  	
 	
  	method perderVida2(){ // cuando se queda sin vidas finaliza el juego. CAMBIARLO A JUEGO
  		if(vida.vidasActuales()>1){
	  		vida.perderVida()
	  		restarVida.reproducir()
  		} else {
  			juego.stageActual().finalizar()
  			gameOver.addVisual()
  			sgameOver.reproducir()
  		}
  	}
  	
  	// hace que felix aparezca y desaparezca mientras esté inmune (perdió una vida)
  	method parpadear() {
  		if(inmune) {
  			invisible = !invisible
	  		game.schedule(200, {
	  			self.parpadear()
	  		})
  		} else {
  			invisible = false
  		}
  	}

	
	/*
	 * establece la nueva posición de felix y de los sensores
	 * ustilizando coordenadas x, y
	 */
	override method positionXY(x, y) {
		super(x,y)
		self.actualizarSensores()
	}
	
	/*
	 * establece la nueva posición de felix y de los sensores
	 */
	override method position(pos) {
		super(pos)
		self.actualizarSensores()
	}
  	
  	override method moverAPosicionyHacerAccion(x,y, accion){
  		if(!saltando) {
	  		mirandoAlaDerecha = x >= self.coordenadaActualX()
	  		saltando = true
			self.animar(self.animacionSaltando())
	  		super(x,y, {
	  			self.animar(self.animacionCayendo())	  			
	  			saltando = false
	  			accion.apply()
	  		})  
	  	  	sonidoSalto.reproducir()
  		}
  	}
  	
  	override method detenerMovimiento() {
  		super()
  		saltando = false
  	}
  	
  	method reset() {
  		self.positionXY(30, 2)
		self.resetearAnimacion()
		self.detenerMovimiento()
		self.actualizarSensores()
		mirandoAlaDerecha = true
		inmune = false 
		reparando = false
		invisible = false
  	}
}

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
	const sensores = []
	
	
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

	method dificultad() = juego.dificultad()

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
			new Sonido (sound = "sonidos/repararVentana.mp3").reproducir() 			
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
		(1..6).forEach({i => self.agregarSensor(x, y)})
	}
	method actualizarSensores() {
		const x = self.position().x()
		const y = self.position().y()
		var i=0
		sensores.get(i).positionXY(x  , y+8) ; i++
		sensores.get(i).positionXY(x  , y+4) ; i++
		sensores.get(i).positionXY(x+2  , y+8) ; i++
		sensores.get(i).positionXY(x+3  , y+8) ; i++
		sensores.get(i).positionXY(x+2  , y) ; i++
		sensores.get(i).positionXY(x+3  , y) ; i++
	}
	
	

	/* agrega un nuevo sensor vertical a felix */
	method agregarSensor(x, y) {
		const sensor = new Sensor()
		sensor.positionXY(x, y)
		sensores.add(sensor)			
	}

  	method mostrarSensores() {
		sensores.forEach({s => s.addVisual()})
  	}
  	method activarSensores() {
		sensores.forEach({s => s.activarDeteccion({ c => if(c.haceDanio()) self.perderVida()  })})
  	}
  	
  	method ocultarSensores() {
		sensores.forEach({s => s.removeVisual()})  		
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
	  		new Sonido (sound = "sonidos/perderVida2.mp3").reproducir()
  		} else {
  			juego.stageActual().finalizar()
  			gameOver.addVisual()
  			new Sonido (sound = "sonidos/sinVidas.mp3").reproducir()
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
	  	  	new Sonido(sound = "sonidos/salto.mp3").reproducir()
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

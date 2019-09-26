###########################################################################
##	 U N I V E R S I D A D   R E Y   J U A N C A R L O S		 ##
## --------------------------------------------------------------------- ##
## G R A D O   E N   I N G E N I E R � A   D E   C O M P U T A D O R E S ##
## --------------------------------------------------------------------- ##
## 	E S T R U C T U R A   D E   C O M P U T A D O R E S		 ##
## --------------------------------------------------------------------- ##
##		R U B � N    G A R C � A   R � O S			 ##
###########################################################################
###############################################################
## --------------------------------------------------------- ##
## D A T O S   D E   L A   M E M O R I A   P R I N C I P A L ##
## --------------------------------------------------------- ##
###############################################################
		.data
# Constante que indica el espacio reservado a la estructura de datos de la agenda ( Reservado 2048 bytes, como tama�o m�ximo para almacenar los datos ).
.eqv STRUCT_RESERVED_MEMORY 2048
.eqv STRUCT_NAME_LENGTH 22
.eqv STRUCT_HOME_LENGTH 10
.eqv STRUCT_MOBILE_LENGTH 10
.eqv STRUCT_EMAIL_LENGTH 21
.eqv STRUCT_ID_LENGTH 1
##############################
## ESTRUCTURA DE DATOS EN C ##
##############################
## struct s_phonebook {	    ##
##	char name[22];      ##
##	char home[10];	    ##
##	char mobile[10];    ##
##	char email[21];	    ##
##	int id; }           ##
##############################
# struct s_phonebook[32] phonebook ( 32 entradas de 64 bytes cada una ).
phonebook:			.space STRUCT_RESERVED_MEMORY
				.align 3 	# Alineaci�n de los datos double en la memoria principal.
end_phonebook:
# Tama�o en bytes de una entrada, 64 bytes ( Reservado tama�o palabra, 4 bytes, 32 bits ).
entry_space:			.word 64
# N�mero m�ximo de entradas que tiene ( Reservado tama�o palabra, 4 bytes, 32 bits ).
n_max:				.space 4
# N�mero de entradas actuales, 0 por defecto, hasta que se cargan los datos ( Reservado tama�o palabra, 4 bytes, 32 bits ).
n_current:			.word 0
# Mombre del fichero que contiene los datos de la agenda.
#file_name_read:		.asciiz	"./phonebook_read.dat"
#file_name_write:		.asciiz	"./phonebook_write.dat"
file_name_read:			.asciiz	"./phonebook.dat"
file_name_write:		.asciiz	"./phonebook.dat"
# Tiras del programa para su impresi�n por pantalla.
string_menu_title:		.asciiz	"\n\n\nAGENDA - MEN�"
string_menu_opt_1:		.asciiz	"\n[1] - Nueva entrada."
string_menu_opt_2:		.asciiz	"\n[2] - Buscar y editar entrada."
string_menu_opt_3:		.asciiz	"\n[3] - Mostrar todas las entradas."
string_menu_opt_4:		.asciiz	"\n[4] - Guardar en fichero y salir."
string_menu_desc:		.asciiz	"\nSeleccione una de las opciones introduciendo el n�mero correspondiente: "
string_menu_no_entries:		.asciiz	"\nNo hay entradas para mostrar."
string_new_entry_title:		.asciiz	"\n\n\nAGENDA - NUEVA ENTRADA"
string_new_entry_entries_1:	.asciiz	"\nN�mero de entradas actuales: "
string_new_entry_entries_2:	.asciiz	", de "
string_new_entry_entries_3:	.asciiz	" disponibles."
string_new_entry_name:		.asciiz	"\nIntroduzca el nombre: "
string_new_entry_home:		.asciiz	"\nIntroduzca el tel�fono fijo: "
string_new_entry_mobile:	.asciiz	"\nIntroduzca el tel�fono movil: "
string_new_entry_email:		.asciiz	"\nIntroduzca el email: "
string_new_entry_error:		.asciiz	"\nError, no queda espacio para m�s entradas: "
string_search_entry_title:	.asciiz	"\n\n\n AGENDA - BUSCAR ENTRADA"
string_search_entry_desc:	.asciiz	"\nIntroduzca el nombre de la persona a buscar: "
string_search_opt_title:	.asciiz	"\n OPCIONES "
string_search_opt_1:		.asciiz	"\n[1] - Modificar entrada. "
string_search_opt_2:		.asciiz	"\n[2] - Eliminar entrada. "
string_search_opt_3:		.asciiz "\n[3] - Continuar. "
string_print_entry_title:	.asciiz	"\n\n\n - ENTRADA - "
string_print_entry_name:	.asciiz	"\nNombre: "
string_print_entry_home:	.asciiz	"\nTel�fono fijo: "
string_print_entry_mobile:	.asciiz	"\nTel�fono movil: "
string_print_entry_email:	.asciiz	"\nEmail: "
string_print_entry_separator:	.asciiz	"\n ----------------"
string_modify_entry_title:	.asciiz	"\n\n\nAGENDA - MODIFICAR ENTRADA"
string_modify_entry_name_j:	.asciiz	"\nPulse '1' para omitir la modificaci�n del nombre, o cualquier otra tecla para continuar: "
string_modify_entry_home_j:	.asciiz	"\nPulse '1' para omitir la modificaci�n del tel�fono fijo, o cualquier otra tecla para continuar: "
string_modify_entry_mobile_j:	.asciiz	"\nPulse '1' para omitir la modificaci�n del tel�fono movil, o cualquier otra tecla para continuar: "
string_modify_entry_email_j:	.asciiz	"\nPulse '1' para omitir la modificaci�n del email, o cualquier otra tecla para continuar: "
# Casos del intercambiador del men�.
menu_switch_cases:		.word '1', '2', '3', '4'
# Casos del intercambiador de b�squeda.
search_switch_cases:		.word '1', '2', '3'
# Caracter salto de linea.
endl:				.byte '\n'
###########################################
## ------------------------------------- ##
## A L G O R I T M O   P R I N C I P A L ##
## ------------------------------------- ##
###########################################
		.text
#####################################
# Lectura del fichero de la agenda. #
#####################################
# Copia el valor del contenido de $S0 ( Puntero al inicio de la estructura de datos agenda ). Al primer argumento de la funci�n.
	la	$a0, phonebook
# Carga la direcci�n de memoria del tama�o de cada entrada, como segundo argumento de la funci�n pasado por referencia.
	la	$a1, entry_space
# Carga la direcci�n de memoria del n�mero de entradas v�lidas de la agenda en disco, como tercer argumento de la funci�n pasado por referencia.
	la	$a2, n_current
#####################################################################################################################################################
# [�AVISO!, SI EL DE LECTURA Y EL DE ESCRITURA SON EL MISMO FICHERO, Y NO EXISTE DICHO FICHERO, AL INTENTAR ABRIRLO PARA LEERLO (CARGANDO AS� LOS   #
# DATOS DEL FICHERO AL INICIO DEL PROGRAMA), EL DESCRIPTOR DEVOLVERA "-1", ARRASTRANDO DICHO ERROR EN LA APERTURA PARA LA ESCRITURA ( EL DESCRIPTOR #
# DEVUELVE TAMBI�N "-1" ) Y NO CREA EL ARCHIVO, DESCONOZCO SI ES UN BUGG DEL MARS].								    #
#####################################################################################################################################################
# Carga la direcci�n de memoria del nombre del fichero, como cuarto argumento de la funci�n pasado por referencia.
	la	$a3, file_name_read
# LLamada a la subrrutina "read_file" ( Encargada de leer las entradas de la agenda contenidas en un fichero ).
	jal	read_file
######################
# Menu de la agenda. #
######################
menu_choose:
	jal	menu
# Control de selecci�n de la opcion del men�.
menu_switch:
# Carga la direcci�n de memoria en la que se encuentran los casos del shitch, en un registro temporal.
	la	$t0, menu_switch_cases
# Ramificaciones.
	lw	$t1, 0($t0)
	lw	$t2, 4($t0)
	lw	$t3, 8($t0)
	lw	$t4, 12($t0)
	beq	$v0, $t1, menu_shitch_case_1
	beq	$v0, $t2, menu_shitch_case_2
	beq	$v0, $t3, menu_shitch_case_3
	beq	$v0, $t4, menu_shitch_case_4
# En caso de una selecci�n inv�lida, se retorna a la selecci�n de opci�n del men�.
menu_shitch_case_default:
	b	menu_choose
#################
# Nueva entrada #
#################
menu_shitch_case_1:
# Copia el valor del contenido de $S0 ( Puntero al inicio de la estructura de datos agenda ). Al primer argumento de la funci�n.
	la	$a0, phonebook
# Carga la direcci�n de memoria del tama�o de cada entrada, como segundo argumento de la funci�n pasado por referencia.
	la	$a1, entry_space
# Carga la direcci�n de memoria del n�mero de entradas v�lidas de la agenda en disco, como tercer argumento de la funci�n pasado por referencia.
	la	$a2, n_current
# Llamada a la subrrutina "new_entry" ( Encargada de introducir una nueva entrada en la agenda ).
	jal	new_entry
# Ramifica al inicio del switch.
	b	menu_choose
##################
# Buscar entrada #
##################
menu_shitch_case_2:
# Copia el valor del contenido de $S0 ( Puntero al inicio de la estructura de datos agenda ). Al primer argumento de la funci�n.
	la	$a0, phonebook
# Carga la direcci�n de memoria del tama�o de cada entrada, como segundo argumento de la funci�n pasado por referencia.
	la	$a1, entry_space
# Carga la direcci�n de memoria del n�mero de entradas v�lidas de la agenda en disco, como tercer argumento de la funci�n pasado por referencia.
	la	$a2, n_current
# Llamada a la subrrutina "new_entry" ( Encargada de introducir una nueva entrada en la agenda ).
	jal	search_entry
# Ramifica al inicio del switch.
	b	menu_choose
##############################
# Mostrar todas las entradas #
##############################
menu_shitch_case_3:
	lw	$s0, n_current
	bnez	$s0, entries_loop
# Imprime por pantalla que no hay entradas que mostrar.
	li      $v0, 4
	la      $a0, string_menu_no_entries
        syscall
	b	menu_choose
entries_loop:
	move 	$s1, $zero
	lw	$s2, entry_space
	la	$s3, phonebook
entries_loop_body:
# Llamada a la subrrutina "print_entry" ( Encargada de imprimir por pantalla la entrada solicitada ).	
	move	$a0, $s3				# Puntero a la entrada solicitada.
	jal	print_entry
	addiu	$s1, $s1, 1
	add	$s3, $s3, $s2
entries_loop_condition:
	bgt	$s0, $s1, entries_loop_body
end_entries_loop:
	b	menu_choose
#########
# Salir #
#########
menu_shitch_case_4:
# Ramifica al final del switch.	
	b	end_menu_switch
end_menu_switch:	
#################################################################
# Escritura de los datos en memoria de la agenda en el fichero. #
#################################################################
# Copia el valor del contenido de $S0 ( Puntero al inicio de la estructura de datos agenda ). Al primer argumento de la funci�n.
	la	$a0, phonebook
# Carga la direcci�n de memoria del tama�o de cada entrada, como segundo argumento de la funci�n pasado por referencia.
	lw	$a1, entry_space
	lw	$a2, n_current		# Puntero al n�mero de entradas de la agenda en memoria.
#####################################################################################################################################################
# [�AVISO!, SI EL DE LECTURA Y EL DE ESCRITURA SON EL MISMO FICHERO, Y NO EXISTE DICHO FICHERO, AL INTENTAR ABRIRLO PARA LEERLO (CARGANDO AS� LOS   #
# DATOS DEL FICHERO AL INICIO DEL PROGRAMA), EL DESCRIPTOR DEVOLVERA "-1", ARRASTRANDO DICHO ERROR EN LA APERTURA PARA LA ESCRITURA ( EL DESCRIPTOR #
# DEVUELVE TAMBI�N "-1" ) Y NO CREA EL ARCHIVO, DESCONOZCO SI ES UN BUGG DEL MARS].								    #
#####################################################################################################################################################
# Carga la direcci�n de memoria del nombre del fichero, como cuarto argumento de la funci�n pasado por referencia.
	la	$a3, file_name_write
# LLamada a la subrrutina "save_file" ( Encargada de guardar las entradas de la agenda en un fichero ).
	jal	save_file
#############################
# Finalizaci�n del programa #
#############################
	li	$v0, 10			# Indica al sistema que se ha finalizado el programa ( C�digo de llamada al sistema "10" ).
	syscall
########################################################################################
###########################
## --------------------- ##
## S U B R R U T I N A S ##
## --------------------- ##
###########################	
menu:
##########
## MEN� ##
########################################################################################
## Descripci�n: Se encarga de imprimir por pantalla el men� principal de la agenda.   ##
## ---------------------------------------------------------------------------------- ##
## No dispone de Argumentos:                                                          ##
########################################################################################
# Imprime por pantalla el men�
	li      $v0, 4
	la      $a0, string_menu_title	# Titulo del men�.
        syscall
#############
	li      $v0, 4
	la      $a0, string_menu_opt_1	# Primera opci�n del men�.
        syscall
#############
	li      $v0, 4
	la      $a0, string_menu_opt_2	# Segunda opci�n del men�.
        syscall
#############
	li      $v0, 4
	la      $a0, string_menu_opt_3	# Tercera opci�n del men�.
        syscall
#############
	li      $v0, 4
	la      $a0, string_menu_opt_4	# Cuarta opci�n del men�.
        syscall
#############
	li      $v0, 4
	la      $a0, string_menu_desc	# Descripci�n del men�.
        syscall
# Obtiene la opcion seleccionada.
	li      $v0, 12			# Lee el caracter introducido mediante el teclado.
	syscall
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr      $ra
########################################################################################
read_file:
###############
## READ_FILE ##
########################################################################################
## Descripci�n: Se encarga de leer las entradas de la agenda contenidas en un fichero ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                                	      ##
##    - $a0: Puntero a los datos de la agenda.                                        ##
##    - $a1: Tama�o de cada una de las entradas de la agenda ( Por referencia ).      ##
##    - $a2: N�mero de entradas totales de la agenda ( Por referencia ).              ##
##    - $a3: Puntero al nombre del fichero ( Por referencia ).                        ##
########################################################################################
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	move	$t3, $a3
#############
# Apertura del fichero.
	li	$v0, 13		# Apertura del fichero ( C�digo de llamada al sistema "13" ).
	move	$a0, $a3	# Nombre del fichero.
	li	$a1, 0		# Tipo de acceso al fichero ( Lectura "0" ).
	li	$a2, 0		# Modo ( Se ignora ).
	syscall			# Llamada al sistema.
	move	$t4, $v0	# Copia del descriptor del fichero en un registro temporal para su posterior uso.
	li	$t7, -1		# Carga el inmediato "-1" para controlar errores en la apertura del fichero.
# Si el fichero no existe, o no se ha podido abrir finaliza la subrrutina.
	beq	$t4, $t7, read_file_exit
#############
# Lectura del tama�o de una entrada de la agenda en el fichero ( 64 bytes ).
	li	$v0, 14		# Lectura del fichero ( C�digo de llamada al sistema "14" ).
	move	$a0, $t4	# Descriptor del fichero que se va a leer.
	move	$a1, $t1	# Inicio de lectura. Puntero al tama�o de una entrada.
	li	$a2, 4		# Fin de la lectura. Tama�o en bytes del dato le�do ( 4 bytes, 32 bits, tama�o palabra ).
	syscall			# Llamada al sistema.
	lw	$t5, 0($t1)	# Se copia tama�o de una entrada en un registro temporal.
#############
# Lectura del n�mero de entradas de la agenda en el fichero.
	li	$v0, 14		# Lectura del fichero ( C�digo de llamada al sistema "14" ).
	move	$a0, $t4	# Descriptor del fichero que se va a leer.
	move	$a1, $t2	# Inicio de lectura. Puntero al n�mero de entradas almacenadas
	li	$a2, 4		# Fin de la lectura. Tama�o en bytes del dato le�do ( 4 bytes, 32 bits, tama�o palabra ).
	syscall			# Llamada al sistema.
	lw	$t6, 0($t2)	# Se copia el n�mero de entradas en un registro temporal.
#############
# Lectura de los datos de la agenda.
	li	$v0, 14		# Lectura del fichero ( C�digo de llamada al sistema "14" ).
	move	$a0, $t4	# Descriptor del fichero que se va a leer.
	move	$a1, $t0	# Inicio de lectura. Puntero al inicio de la estructura de datos de la agenda.
	mul	$a2, $t5, $t6	# Fin de la lectura. Tama�o en bytes de la agenda ( Multiplicaci�n del n�mero de entradas por el tama�o de la entrada ).
	syscall			# Llamada al sistema.
#############
# Cierre del fichero.
	li	$v0, 16		# Cierre del fichero ( C�digo de llamada al sistema "16" ).
	move	$a0, $t4	# Descriptor del fichero que se va a cerrar.
	syscall			# Llamada al sistema.
#############
read_file_exit:
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
save_file:
###############
## SAVE_FILE ##
########################################################################################
## Descripci�n: Se encarga de guardar las entradas de la agenda en un fichero.	      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                                	      ##
##    - $a0: Puntero a los datos de la agenda.                                        ##
##    - $a1: Tama�o de cada una de las entradas de la agenda ( Por copia ).           ##
##    - $a2: N�mero de entradas totales de la agenda ( Por copia ).                   ##
##    - $a3: Puntero al nombre del fichero.                        		      ##
########################################################################################
# Crear un marco de pila para una variable local
	addi	$sp, $sp, -8
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	move	$t3, $a3
#############
# Apertura del fichero.
	li	$v0, 13		# Apertura del fichero ( C�digo de llamada al sistema "13" ).
	move	$a0, $a3	# Nombre del fichero.
	li	$a1, 1		# Tipo de acceso al fichero ( Escritura "1" ).
	li	$a2, 0		# Modo ( Se ignora ).
	syscall			# Llamada al sistema.
	move	$t4, $v0	# Copia del descriptor del fichero en un registro temporal para su posterior uso.
#############	
# Escritura del tama�o de una entrada de la agenda en el fichero ( 64 bytes ).
	li	$v0, 15		# Escritura del fichero ( C�digo de llamada al sistema "15" ).
	move	$a0, $t4	# Descriptor del fichero que se va a escribir.
	sw	$t1, 0($sp)	# Se guarda el tama�o de una entrada en la primera posici�n de la pila para su posterior uso.
	la	$a1, 0($sp)	# Se envia como argumento el tama�o de una entrada para escribirlo en el fichero.
	li	$a2, 4		# Tama�o en bytes del dato a escribir ( 4 bytes, 32 bits, tama�o palabra ).
	syscall			# Llamada al sistema.
#############
# Escritura del n�mero de entradas de la agenda en el fichero.
	li	$v0, 15		# Escritura del fichero ( C�digo de llamada al sistema "15" ).
	move	$a0, $t4	# Descriptor del fichero que se va a escribir.
	sw	$t2, 4($sp)	# Se guarda el n�mero de entradas en la segunda posici�n de la pila para su posterior uso.
	la	$a1, 4($sp)	# Se envia como argumento el n�mero de entradas para escribirlo en el fichero.
	li	$a2, 4		# Tama�o en bytes del dato a escribir ( 4 bytes, 32 bits, tama�o palabra ).
	syscall
#############
# Escritura de los datos de la agenda almacenados en la memoria.
	li	$v0, 15		# Escritura del fichero ( C�digo de llamada al sistema "15" ).
	move	$a0, $t4	# Descriptor del fichero que se va a escribir.
	move	$a1, $t0	# Puntero al inicio de la estructura de datos de la agenda.
	mul	$a2, $t1, $t2	# Tama�o en bytes de la agenda ( Multiplicaci�n del n�mero de entradas por el tama�o de la entrada ).
	syscall
#############
# Cierre del fichero.
	li	$v0, 16		# Cierre del fichero ( C�digo de llamada al sistema "16" ).
	move	$a0, $t4	# Descriptor del fichero que se va a cerrar.
	syscall			# Llamada al sistema.
#############
# Destrucci�n del marco de pila usado en la subrrutina ( Liberaci�n del espacio reservado en el Stack ).
	addi	$sp, $sp, 8
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
new_entry:
###############
## NEW_ENTRY ##
########################################################################################
## Descripci�n: Se encarga de introducir una nueva entrada en la agenda.              ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a los datos de la agenda.                                        ##
##    - $a1: Tama�o de cada una de las entradas de la agenda ( Por referencia ).      ##
##    - $a2: N�mero de entradas totales de la agenda ( Por referencia ).              ##
########################################################################################
# Crear un marco de pila para una variable local
	addi	$sp, $sp, -8
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0
	lw	$t1, 0($a1)
	lw	$t2, 0($a2)
# Guarda en el marco de la pila los argumentos necesarios, para su posterior uso.
# 0 - 3  -> Direcci�n de retorno de la subrrutina.
# 4 - 7  -> Direcci�n de memoria del n�mero de entradas totales de la agenda.
	sw	$ra, 0($sp)		
	sw	$a2, 4($sp)			
#################################################################
# C�lculo del n�mero m�ximo de entradas que caben en la agenda. #
#################################################################
	li	$t3, STRUCT_RESERVED_MEMORY
	div	$t4, $t3, $t1			# Bytes reservados para la estructura de datos dividido entre el tama�o de cada una de las entradas.	
# Imprime por pantalla el t�tulo.
	li      $v0, 4
	la      $a0, string_new_entry_title 	# Titulo.
        syscall
# Imprime la informaci�n del n�mero de entradas disponibles.
	li      $v0, 4
	la      $a0, string_new_entry_entries_1 # Informaci�n sobre el n�mero de entradas 1.
        syscall
#########
	li      $v0, 1
	move    $a0, $t2			# N�mero de entradas actuales.
        syscall
#########
	li      $v0, 4
	la      $a0, string_new_entry_entries_2 # Informaci�n sobre el n�mero de entradas 2.
        syscall
#########
	li      $v0, 1
	move    $a0, $t4			# N�mero m�ximo de entradas.
        syscall
#########
	li      $v0, 4
	la      $a0, string_new_entry_entries_3 # Informaci�n sobre el n�mero de entradas 3.
        syscall
# Si quedan entradas disponibles, ramifica.
	bne	$t2, $t4, new_entry_add
# En caso contrario finaliza la ejecuci�n de la subrrutina.
	li      $v0, 4
	la      $a0, string_new_entry_error 	# Error de entradas disponibles.
        syscall	
	b	new_entry_exit
new_entry_add:
#################################
# char name[STRUCT_NAME_LENGTH] #
#################################
# C�lculo de la direcci�n de memoria que le corresponde al primer elemento de la nueva entrada.
	mul	$t1, $t1, $t2			# Se multiplica el tama�o de una entrada por el n�mero de entradas actuales.
	add	$t0, $t0, $t1			# Se suma el resultado de la operaci�n anterior con el de la direcci�n de memoria inicial de los datos de la agenda para obtener su ubicaci�n.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_name	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Copia de seguridad de los registros temporales antes de la llamada a la subrrutina.
	sw	$t0, 8($sp)
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_NAME_LENGTH		# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 8($sp)
#################################
# char home[STRUCT_HOME_LENGTH] #
#################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_NAME_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_home	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Copia de seguridad de los registros temporales antes de la llamada a la subrrutina.
	sw	$t0, 8($sp)
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_HOME_LENGTH		# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 8($sp)
#####################################
# char mobile[STRUCT_MOBILE_LENGTH] #
#####################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_HOME_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_mobile	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Copia de seguridad de los registros temporales antes de la llamada a la subrrutina.
	sw	$t0, 8($sp)
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_MOBILE_LENGTH	# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 8($sp)
###################################
# char email[STRUCT_EMAIL_LENGTH] #
###################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_MOBILE_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_email	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Copia de seguridad de los registros temporales antes de la llamada a la subrrutina.
	sw	$t0, 8($sp)
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_EMAIL_LENGTH	# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 8($sp)
##########
# int id #
##########
# Incremento del n�mero de entradas actuales en la agenda.
	lw	$t1, 4($sp)		
	lw	$t2, 0($t1)			# Carga el n�mero de entradas actuales en una variable temporal.
	addiu	$t2, $t2, 1			# Incrementa el n�mero de entradas en una unidad.
	sw	$t2, 0($t1)			# Guarda en memoria el n�mero de entradas incrementado.
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_EMAIL_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
        sb	$t2, 0($t0)			# Direcci�n del quinto elemento de la estructura de datos "id".
new_entry_exit:
#############
# Restaura la direcci�n de memoria de retorno de la subrrutina.
	lw	$ra, 0($sp)			
#############
# Destrucci�n del marco de pila usado en la subrrutina ( Liberaci�n del espacio reservado en el Stack ).
	addi	$sp, $sp, 8
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
search_entry:
##################
## SEARCH_ENTRY ##
########################################################################################
## Descripci�n: Se encarga de buscar la entrada solicitada, si existe imprime         ##
## los datos obtenidos.              						      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a los datos de la agenda.                                        ##
##    - $a1: Tama�o de cada una de las entradas de la agenda ( Por referencia ).      ##
##    - $a2: N�mero de entradas actuales de la agenda ( Por referencia ).             ##
########################################################################################
# Creaci�n de un marco de pila para guardar informaci�n hasta el final de la subrrutina.
	addi	$sp, $sp, -72
# Guarda en el marco de la pila los argumentos necesarios, para su posterior uso.
#  0 - 3  -> Direcci�n de retorno de la subrrutina.
#  4 - 7  -> Direcci�n de memoria inicial de los datos de la agenda.
#  8 - 11 -> Direcci�n de memoria del tama�o de cada una de las entradas de la agenda.
# 12 - 15 -> Direcci�n de memoria del n�mero de entradas actuales de la agenda.
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)			
	sw	$a2, 12($sp)
# Imprime por pantalla.
	li      $v0, 4
	la      $a0, string_search_entry_title 		# Titulo.
        syscall	
	li      $v0, 4
	la      $a0, string_search_entry_desc 		# Descripci�n.
        syscall
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        la	$a0, 16($sp)				# Guarda el nombre introducido en la pila.
       	li      $a1, STRUCT_NAME_LENGTH			# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
#############
# Copia de los argumentos de la funci�n en registros temporales.
	lw	$t0, 4($sp)
	lw	$t2, 12($sp)
	lw	$t2, 0($t2)
#####################
# Bucle de b�squeda #
#####################
search_while:
	move	$t3, $zero				# Copia el valor "0" en un registro temporal, necesario para las iteracciones del bucle.
	b	search_while_condition			# Ramifica a la condici�n del while.
# Cuerpo del while.
search_while_body:
	move	$t4, $zero				# Carga del inmediato 0 en un registro temporal, necesario para las iteracciones del bucle.
	la 	$t5, 16($sp)				# Obtiene la direcci�n de memoria de la pila donde empieza la cadena de caracteres a buscar.
	b	search_entry_byte_equal_condition
search_entry_byte_equal:
	add	$t6, $t4, $t0				# Incremento de la direcci�n de memoria de la entrada byte a byte.
	lbu	$t6, 0($t6)				# Obtiene el byte para su posterior comparaci�n.
	add	$t7, $t4, $t5				# Incremento de la direcci�n de memoria de la entrada byte a byte.
	lbu	$t7, 0($t7)				# Obtiene el byte para su posterior comparaci�n.
	addiu	$t4, $t4, 1				# Incrementa el iterador en una unidad.
# Si el byte obtenido de la entrada por teclado es nulo, significa que es el �ltimo caracter de la cadena, por lo que si todos los bits anteriores son iguales, imprime por pantalla la entrada.
# [Funciona como un "like" de una Base de datos SQL, ya que no tiene en cuenta los bytes siguientes de la entrada].
	beq	$t7, $zero, search_entry_equals
	bne	$t6, $t7, search_next_entry		# Si los bytes obtenidos no coinciden se ramifica a la siguiente entrada.
# Se comparan los bytes hasta que se alcanza la longitud de la cadena.
search_entry_byte_equal_condition:
	blt	$t4, STRUCT_NAME_LENGTH, search_entry_byte_equal
search_entry_equals:
# Si todos los bytes son iguales, se ha encontrado la entrada solicitada y se procede como se especifica.
# Copia de seguridad de los registros temporales antes de la llamada a la subrrutina.
	sw	$t0, 40($sp)
	sw	$t1, 44($sp)
	sw	$t2, 48($sp)
	sw	$t3, 52($sp)
	sw	$t4, 56($sp)
	sw	$t5, 60($sp)
	sw	$t6, 64($sp)
	sw	$t7, 68($sp)	
# Llamada a la subrrutina "print_entry" ( Encargada de imprimir por pantalla la entrada solicitada ).	
	move	$a0, $t0				# Puntero a la entrada solicitada.
	jal	print_entry
search_choose_options:
# Imprime por pantalla las opciones de modificar o eliminar, la entrada encontrada.
	li      $v0, 4
	la      $a0, string_search_opt_title 		# Titulo.
        syscall	
	li      $v0, 4
	la      $a0, string_search_opt_1 		# Modificar.
        syscall
        li      $v0, 4
	la      $a0, string_search_opt_2 		# Eliminar.
        syscall
        li      $v0, 4
	la      $a0, string_search_opt_3 		# Continuar.
        syscall
         li      $v0, 4
	la      $a0, string_menu_desc 			# Descripci�n.
        syscall
# Obtiene la opcion seleccionada.
	li      $v0, 12			# Lee el caracter introducido mediante el teclado.
	syscall
# Carga la direcci�n de memoria en la que se encuentran los casos del shitch, en un registro temporal.
	la	$t1, search_switch_cases
# Ramificaciones.
	lw	$t2, 0($t1)
	lw	$t3, 4($t1)
	lw	$t4, 8($t1)
	beq	$v0, $t2, search_shitch_case_1
	beq	$v0, $t3, search_shitch_case_2
	beq	$v0, $t4, search_shitch_case_3
# En caso de una selecci�n inv�lida, se retorna a la selecci�n de opci�n del men�.
search_shitch_case_default:
	b	search_choose_options
#####################
# Modificar entrada #
#####################
search_shitch_case_1:
# Restauraci�n del puntero a la entrada actual.
	lw	$t0, 40($sp)
# Llamada a la subrrutina "modify_entry" ( Encargada de modificar la entrada solicitada ).	
	move	$a0, $t0				# Puntero a la entrada solicitada.
	jal	modify_entry
# Ramifica al final del switch.
	b	end_search_switch
####################
# Eliminar entrada #
####################
search_shitch_case_2:
# Restauraci�n del puntero a la entrada actual.
	lw	$t0, 40($sp)
# Llamada a la subrrutina "delete_entry" ( Encargada de eliminar la entrada solicitada ).	
	move	$a0, $t0				# Puntero a la entrada solicitada.
	lw	$a1, 52($sp)				# Iterador del bucle de entradas.
	addiu	$a1, $a1, 1				# N�mero de entrada actual.
	lw	$a2, 12($sp)				# Direcci�n de memoria del n�mero de entradas actuales de la agenda.
	lw	$a3, 8($sp)				# Direcci�n de memoria del tama�o de cada una de las entradas de la agenda.
	lw	$a3, 0($a3)				# Tama�o de cada una de las entradas de la agenda.
	jal	delete_entry
# Ramifica al final del switch.
	b	end_search_switch
#############
# Continuar #
#############
search_shitch_case_3:
# Ramifica al final del switch.
	b	end_search_switch
end_search_switch:
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 40($sp)
	lw	$t1, 44($sp)
	lw	$t2, 48($sp)
	lw	$t3, 52($sp)
	lw	$t4, 56($sp)
	lw	$t5, 60($sp)
	lw	$t6, 64($sp)
	lw	$t7, 68($sp)	
#############
search_next_entry:
# C�lculo de la direcci�n de memoria que le corresponde a la siguiente entrada.
	lw	$t1, 8($sp)				# Carga en el registro temporal la direcci�n de memoria del del tama�o de cada una de las entradas de la agenda.
	lw	$t1, 0($t1)				# Obtiene el valor del tama�o de cada una de las entradas de la agenda a partir de su direcci�n de memoria.
	add	$t0, $t0, $t1				# Se suma el resultado de la operaci�n anterior con el de la direcci�n de memoria inicial de los datos de la agenda para obtener su ubicaci�n.
# Incremento del iterador.
	addiu	$t3, $t3, 1				# Incrementa en una unidad el iterador del bucle.
# Condici�n del while.
search_while_condition:
	bgt	$t2, $t3, search_while_body		# Repite desde la primera entrada hasta la �ltima.
end_search_while:
#############
# Restaura la direcci�n de memoria de retorno de la subrrutina.
	lw	$ra, 0($sp)
#############
# Destrucci�n del marco de pila usado en la subrrutina ( Liberaci�n del espacio reservado en el Stack ).
	addi	$sp, $sp, 72
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
modify_entry:
##################
## MODIFY_ENTRY ##
########################################################################################
## Descripci�n: Se encarga de modificar la entrada solicitada.    		      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a la entrada solicitada.                                         ##
########################################################################################
# Crear un marco de pila para una variable local
	addi	$sp, $sp, -8
# Guarda en el marco de la pila los argumentos necesarios, para su posterior uso.
# 0 - 3  -> Direcci�n de retorno de la subrrutina.
# 4 - 7  -> Puntero a la entrada solicitada.
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0
# Imprime por pantalla el t�tulo y la descripci�n.
	li      $v0, 4
	la      $a0, string_modify_entry_title 	# Titulo.
        syscall
modify_entry_name:
#################################
# char name[STRUCT_NAME_LENGTH] #
#################################
# Omisi�n de modificaci�n de propiedad.
	li      $v0, 4
	la      $a0, string_modify_entry_name_j
        syscall
# Obtiene la tecla introducida.
	li      $v0, 12				# Lee el caracter introducido mediante el teclado.
	syscall
	beq	$v0, '1', modify_entry_home	# En caso de omisi�n salta a la siguiente propioedad
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_name	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_NAME_LENGTH		# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 4($sp)
modify_entry_home:
#################################
# char home[STRUCT_HOME_LENGTH] #
#################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_NAME_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Omisi�n de modificaci�n de propiedad.
	li      $v0, 4
	la      $a0, string_modify_entry_home_j
        syscall
# Obtiene la tecla introducida.
	li      $v0, 12				# Lee el caracter introducido mediante el teclado.
	syscall
	beq	$v0, '1', modify_entry_mobile	# En caso de omisi�n salta a la siguiente propioedad
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_home	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_HOME_LENGTH		# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 4($sp)
modify_entry_mobile:
#####################################
# char mobile[STRUCT_MOBILE_LENGTH] #
#####################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_HOME_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Omisi�n de modificaci�n de propiedad.
	li      $v0, 4
	la      $a0, string_modify_entry_mobile_j
        syscall
# Obtiene la tecla introducida.
	li      $v0, 12				# Lee el caracter introducido mediante el teclado.
	syscall
	beq	$v0, '1', modify_entry_email	# En caso de omisi�n salta a la siguiente propioedad
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_mobile	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_MOBILE_LENGTH	# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
# Restauraci�n de los valores previos de los registros, antes de la llamada a la subrrutina.
	lw	$t0, 4($sp)
modify_entry_email:
###################################
# char email[STRUCT_EMAIL_LENGTH] #
###################################
# C�lculo de la posici�n de memoria correspondiente a la propiedad.
	add	$t0, $t0, STRUCT_MOBILE_LENGTH	# Se suma la longitud en bytes de la anterior propiedad para obtener la ubicaci�n de la propiedad actual.
# Omisi�n de modificaci�n de propiedad.
	li      $v0, 4
	la      $a0, string_modify_entry_email_j
        syscall
# Obtiene la tecla introducida.
	li      $v0, 12				# Lee el caracter introducido mediante el teclado.
	syscall
	beq	$v0, '1', modify_entry_end	# En caso de omisi�n salta a la siguiente propioedad
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_new_entry_email	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# Llamada a la subrrutina "read_input_string" ( Encargada de obtener una cadena de car�cteres introducida mediante teclado. Escapa los saltos de linea ).
        move	$a0, $t0			# Direcci�n de memoria donde se guardar� la cadena de caracteres.
       	li      $a1, STRUCT_EMAIL_LENGTH	# Tama�o m�ximo de la cadena a leer.
	jal	read_input_string
modify_entry_end:
#############
# Restaura la direcci�n de memoria de retorno de la subrrutina.
	lw	$ra, 0($sp)
#############
# Destrucci�n del marco de pila usado en la subrrutina ( Liberaci�n del espacio reservado en el Stack ).
	addi	$sp, $sp, 8
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
delete_entry:
##################
## DELETE_ENTRY ##
########################################################################################
## Descripci�n: Se encarga de eliminar la entrada solicitada    		      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a la entrada solicitada.                                         ##
##    - $a1: N�mero de entrada actual ( Por valor / copia ).           		      ##
##    - $a2: N�mero de entradas actuales de la agenda ( Por referencia ).             ##
##    - $a3: Tama�o de cada una de las entradas de la agenda ( Por valor / copia ).   ##
########################################################################################
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0			# Puntero a la entrada actual.
	move	$t1, $a1			# Iterador del bucle de repetici�n desde la entrada a eliminar.
	lw	$t3, 0($a2)			# N�mero de entradas totales de la agenda.
	add	$t0, $t0, $a3			# Se incrementa la direcci�n de memoria para obtener la entrada siguiente.
# Ramifica a la condici�n del while.
	b	delete_entry_while_condition
# Cuando se elimina un elemento han de desplazarse todos los siguientes una posici�n a la izquierda. Para ello se copia la informaci�n de la entrada siguiente, en la entrada actual.
delete_entry_while:
#################################
# char name[STRUCT_NAME_LENGTH] #
#################################
# Se copia la informaci�n de la siguiente entrada en la entrada actual.
	move 	$t4, $zero
	b	delete_entry_copy_name_bytes_condition
delete_entry_copy_name_bytes:
	lb	$t2, 0($t0)
	sb	$t2, 0($a0)
	addiu	$t0, $t0, 1			# Se incrementa la posici�n de memoria de la siguiente entrada en un byte.
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_copy_name_bytes_condition:
	blt	$t4, STRUCT_NAME_LENGTH, delete_entry_copy_name_bytes
end_delete_entry_copy_name_bytes:
#################################
# char home[STRUCT_HOME_LENGTH] #
#################################
# Se copia la informaci�n de la siguiente entrada en la entrada actual.
	move 	$t4, $zero
	b	delete_entry_copy_home_bytes_condition
delete_entry_copy_home_bytes:
	lb	$t2, 0($t0)
	sb	$t2, 0($a0)
	addiu	$t0, $t0, 1			# Se incrementa la posici�n de memoria de la siguiente entrada en un byte.
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_copy_home_bytes_condition:
	blt	$t4, STRUCT_HOME_LENGTH, delete_entry_copy_home_bytes
end_delete_entry_copy_home_bytes:
#####################################
# char mobile[STRUCT_MOBILE_LENGTH] #
#####################################
# Se copia la informaci�n de la siguiente entrada en la entrada actual.
	move 	$t4, $zero
	b	delete_entry_copy_mobile_bytes_condition
delete_entry_copy_mobile_bytes:
	lb	$t2, 0($t0)
	sb	$t2, 0($a0)
	addiu	$t0, $t0, 1			# Se incrementa la posici�n de memoria de la siguiente entrada en un byte.
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_copy_mobile_bytes_condition:
	blt	$t4, STRUCT_MOBILE_LENGTH, delete_entry_copy_mobile_bytes
end_delete_entry_copy_mobile_bytes:
###################################
# char email[STRUCT_EMAIL_LENGTH] #
###################################
# Se copia la informaci�n de la siguiente entrada en la entrada actual.
	move 	$t4, $zero
	b	delete_entry_copy_email_bytes_condition
delete_entry_copy_email_bytes:
	lb	$t2, 0($t0)
	sb	$t2, 0($a0)
	addiu	$t0, $t0, 1			# Se incrementa la posici�n de memoria de la siguiente entrada en un byte.
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_copy_email_bytes_condition:
	blt	$t4, STRUCT_EMAIL_LENGTH, delete_entry_copy_email_bytes
end_delete_entry_copy_email_bytes:
##########
# int id #
##########
# Se copia la informaci�n de la siguiente entrada en la entrada actual.
	move 	$t4, $zero
	b	delete_entry_copy_id_bytes_condition
delete_entry_copy_id_bytes:
	lb	$t2, 0($t0)
	sb	$t2, 0($a0)
	addiu	$t0, $t0, 1			# Se incrementa la posici�n de memoria de la siguiente entrada en un byte.
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_copy_id_bytes_condition:
	blt	$t4, STRUCT_ID_LENGTH, delete_entry_copy_id_bytes
end_delete_entry_copy_id_bytes:
#############
# Incremento del iterador y la direcci�n de memoria de la entrada actual.
	addiu	$t1, $t1, 1			# Incrementa en una unidad el iterador del bucle.
delete_entry_while_condition:
	bgt	$t3, $t1, delete_entry_while	# Repite hasta la �ltima entrada.
end_delete_entry_while:
# En la �ltima entrada se copian nulos.
#################################
# char name[STRUCT_NAME_LENGTH] #
#################################
# Se eliminan los bytes.
	move 	$t4, $zero
	b	delete_entry_delete_name_bytes_condition
delete_entry_delete_name_bytes:
	sb	$zero, 0($a0)
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_delete_name_bytes_condition:
	blt	$t4, STRUCT_NAME_LENGTH, delete_entry_delete_name_bytes
end_delete_entry_delete_name_bytes:
#################################
# char home[STRUCT_HOME_LENGTH] #
#################################
# Se eliminan los bytes.
	move 	$t4, $zero
	b	delete_entry_delete_home_bytes_condition
delete_entry_delete_home_bytes:
	sb	$zero, 0($a0)
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_delete_home_bytes_condition:
	blt	$t4, STRUCT_HOME_LENGTH, delete_entry_delete_home_bytes
end_delete_entry_delete_home_bytes:
#####################################
# char mobile[STRUCT_MOBILE_LENGTH] #
#####################################
# Se eliminan los bytes.
	move 	$t4, $zero
	b	delete_entry_delete_mobile_bytes_condition
delete_entry_delete_mobile_bytes:
	sb	$zero, 0($a0)
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_delete_mobile_bytes_condition:
	blt	$t4, STRUCT_MOBILE_LENGTH, delete_entry_delete_mobile_bytes
end_delete_entry_delete_mobile_bytes:
###################################
# char email[STRUCT_EMAIL_LENGTH] #
###################################
# Se eliminan los bytes.
	move 	$t4, $zero
	b	delete_entry_delete_email_bytes_condition
delete_entry_delete_email_bytes:
	sb	$zero, 0($a0)
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_delete_email_bytes_condition:
	blt	$t4, STRUCT_EMAIL_LENGTH, delete_entry_delete_email_bytes
end_delete_entry_delete_email_bytes:
##########
# int id #
##########
# Se eliminan los bytes.
	move 	$t4, $zero
	b	delete_entry_delete_id_bytes_condition
delete_entry_delete_id_bytes:
	sb	$zero, 0($a0)
	addiu	$a0, $a0, 1			# Se incrementa la posici�n de memoria de la entrada actual en un byte.
	addiu	$t4, $t4, 1			# Incrementa el iterador en una unidad.
delete_entry_delete_id_bytes_condition:
	blt	$t4, STRUCT_ID_LENGTH, delete_entry_delete_id_bytes
end_delete_entry_delete_id_bytes:
# Decremento del n�mero de entradas.
	subiu	$t3, $t3, 1
	sw	$t3, 0($a2)
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################
print_entry:
#################
## PRINT_ENTRY ##
########################################################################################
## Descripci�n: Se encarga de imprimir por pantalla la entrada solicitada	      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a la entrada solicitada.                                         ##
########################################################################################
# Copia de los argumentos de la funci�n en registros temporales.
	move	$t0, $a0
##########
# TITULO #
##########
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_print_entry_title 	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
#################################
# char name[STRUCT_NAME_LENGTH] #
#################################
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la    	$a0, string_print_entry_name	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	move    $a0, $t0			# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
#################################
# char home[STRUCT_HOME_LENGTH] #
#################################
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la    	$a0, string_print_entry_home	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# C�lculo de la direcci�n de memoria que le corresponde al segundo elemento de la nueva entrada.
	add	$t0, $t0, STRUCT_NAME_LENGTH	# Se suma el resultado de la operaci�n anterior con el de la direcci�n de memoria de la propiedad anterior obtener calcular su ubicaci�n.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	move    $a0, $t0			# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
#####################################
# char mobile[STRUCT_MOBILE_LENGTH] #
#####################################
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la    	$a0, string_print_entry_mobile	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# C�lculo de la direcci�n de memoria que le corresponde al segundo elemento de la nueva entrada.
	add	$t0, $t0, STRUCT_HOME_LENGTH	# Se suma el resultado de la operaci�n anterior con el de la direcci�n de memoria de la propiedad anterior obtener calcular su ubicaci�n.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	move    $a0, $t0			# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
###################################
# char email[STRUCT_EMAIL_LENGTH] #
###################################
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la    	$a0, string_print_entry_email	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
# C�lculo de la direcci�n de memoria que le corresponde al segundo elemento de la nueva entrada.
	add	$t0, $t0, STRUCT_MOBILE_LENGTH	# Se suma el resultado de la operaci�n anterior con el de la direcci�n de memoria de la propiedad anterior obtener calcular su ubicaci�n.
# Impresi�n por pantalla.
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	move    $a0, $t0			# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
#############
# SEPARADOR #
#############
	li      $v0, 4				# Imprime la cadena de caracteres ( C�digo de llamada al sistema "4" ).
	la      $a0, string_print_entry_separator	# Cadena de caracteres ( Tira ) a imprimir por pantalla.
        syscall					# Llamada al sistema.
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr	$ra
########################################################################################	
read_input_string:
#######################
## READ_INPUT_STRING ##
########################################################################################
## Descripci�n: Obtiene una cadena de caracteres introducida mediante teclado. Escapa ##
## los saltos de l�nea.	      							      ##
## ---------------------------------------------------------------------------------- ##
## Argumentos:                                                        	              ##
##    - $a0: Puntero a la entrada solicitada.                                         ##
##    - $a1: N�mero m�ximo de caracteres a leer.				      ##
########################################################################################
# Obtenci�n de la entrada por teclado.
	li      $v0, 8 						# Lee la cadena de caracteres introducidos mediante el teclado ( C�digo de llamada al sistema "8" ).
	syscall							# Llamada al sistema.
# Elimina el salto de linea de string obtenido.
	lbu  	$t1, endl					# Carga el caracter "\n" en un registro temporal.
	move	$t2, $zero					# Se inicializa el registro temporal iterador a cero.
read_input_string_delete_endl:			
	beq	$a1, $t2, end_read_input_string_delete_endl	# Controla que el n�mero de bytes comprobados no sobrepase a los que est�n asignados a la propiedad.
	add	$t3, $t2, $a0					# Incremento de la direcci�n de memoria byte a byte.
	lbu	$t4, 0($t3)					# Obtiene el byte para su posterior comparaci�n.
	addiu	$t2, $t2, 1					# Incrementa el iterador en una unidad.
	bne	$t4, $t1, read_input_string_delete_endl		# Si el byte obtenido no coincide con el de salto de linea se ejecuta otra iteraci�n hasta el �ltimo byte de la propiedad.
	sb	$zero, 0($t3)					# En caso de coincidir, se sobreescribe el bit por el caracter nulo.
end_read_input_string_delete_endl:
#############
# Retorno a la siguiente instrucci�n despu�s de la llamada a la subrrutina.
	jr		$ra
########################################################################################

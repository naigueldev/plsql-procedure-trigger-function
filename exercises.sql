-- PROCEDURE
CREATE OR REPLACE PROCEDURE testaExcecao (nc in number) IS
	a number(6,2);
	erro EXCEPTION;
	BEGIN
		SELECT saldo INTO a FROM conta WHERE numero = nc;
		if (a > 150) then
			a := a + 1;
			DBMS_OUTPUT.PUT_LINE('Feito o acrescimo!');
		else
			raise erro;
		end if;

		EXCEPTION
			WHEN erro THEN
				raise_application_error(-20001,'Condicao nao cumprida!');
	END testaExcecao;

	EXEC testaExcecao(7392);

-- TRIGGER

CREATE OR REPLACE TRIGGER tg_auditaTabela
AFTER UPDATE ON produtos
FOR EACH ROW
WHEN (OLD.precounitario <> NEW.precounitario)
BEGIN
	INSERT INTO log_produtos(id,codigo,precounitarioAntigo,precounitarioNovo,
		dataAlteracao,usuario) values
		(seq_id.nextval, :OLD.codigo,:OLD.precounitario,:NEW.precounitario, sysdate, user);
END tg_auditaTabela;

update produtos 
set precounitario = 1.49
qhere codigo = 101;			



-- FUNCTION

CREATE OR REPLACE FUNCTION f_verificarenda(c int)
RETURN NUMBER IS
varR NUMBER;
limite NUMBER;
BEGIN
	SELECT renda INTO varR from cliente where codigo = c;
	IF ( (varR > 500) and (varR <= 3000) ) THEN
		limite := 900;
	ELSE
		limite := 300;
	END IF;
RETURN (limite);
END f_verificarenda;

-- executar function
select f_verificarenda(21) from dual;
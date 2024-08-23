/**
 * 
 */

function onAddDashTel(val) {
	if (!val) return '';
	val = val.toString();
	val = val.replace(/[^0-9]/g, '')
	
	let tmp = ''
	if( val.length < 4){
		return val;
	} else if(val.length <= 7) {
		tmp += val.substring(0, 3);
		tmp += '-';
		tmp += val.substring(3, val.length);
		return tmp;
	} else if(val.length == 8) {
		tmp += val.substring(0, 4);
		tmp += '-';
		tmp += val.substring(4, val.length);
		return tmp;
	} else if(val.length < 10) {
		tmp += val.substring(0, 2);
		tmp += '-';
		tmp += val.substring(2, 5);
		tmp += '-';
		tmp += val.substring(5, val.length);
		return tmp;
	} else if(val.length < 11) {
		if(val.substring(0, 2) =='02') { //02-1234-5678
			tmp += val.substring(0, 2);
			tmp += '-';
			tmp += val.substring(2, 6);
			tmp += '-';
			tmp += val.substring(6, val.length);
			return tmp;
		} else { //010-123-4567
			tmp += val.substring(0, 3);
			tmp += '-';
			tmp += val.substring(3, 6);
			tmp += '-';
			tmp += val.substring(6, val.length);
			return tmp;
		}
	} else { //010-1234-5678
		tmp += val.substring(0, 3);
		tmp += '-';
		tmp += val.substring(3, 7);
		tmp += '-';
		tmp += val.substring(7, val.length);
		return tmp;
	}
}
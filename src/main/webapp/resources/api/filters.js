var Ft = {
    ftBiMode: function(val) {
        if (val === 'A') {
            return '지명경쟁입찰';
        } else if (val === 'B') {
            return '일반경쟁입찰';
        } else {
            return val;
        }
    },
    ftInsMode: function(val) {
        if (val === '1') {
            return '파일등록';
        } else if (val === '2') {
            return '직접입력';
        }
    },
    ftIngTag: function(val) {
        if (val === 'A5') {
            return '입찰완료';
        } else if (val === 'A7') {
            return '유찰';
        }
    },
    numberWithCommas: function(val) {
        if (!val) return '';
        else {
            val = Math.round(val);
            return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    },
    ftFileFlag: function(val) {
        if (val === '0') {
            return '대내용';
        } else if (val === '1') {
            return '대외용';
        }
    },
    ftSuccYn: function(val) {
        if (val === 'Y') {
            return '낙찰';
        } else if (val === 'N') {
            return '';
        }
    },
    ftEsmtYn: function(val) {
        if (val === '0') {
            return '';
        } else if (val === '1') {
            return '공고확인';
        } else if (val === '2') {
            return '상세';
        }
    },
    ftOpenAttSign: function(val) {
        if (val === 'Y') {
            return '[서명 확인]';
        } else if (val === 'N') {
            return '[서명 미확인]';
        } else {
            return '';
        }
    },
    ftBdComp: function(data, esmtAmt) {
        if (data.bdAmt <= 0) {
            return '';
        } else {
            let rtn = ((data.bdAmt - (data.bdAmt - esmtAmt)) / data.bdAmt * 100);
            return rtn.toFixed(1) + "%";
        }
    },

    ftEsmtAmt: function(cust) {
        if (this.isEmpty(cust.esmtAmt)) return ''
        else {
            let esmtCurr = this.defaultIfEmpty(cust.esmtCurr, '');
            let esmtAmt = cust.esmtAmt;
            return esmtCurr + (esmtCurr !== '' ? ' ' : '') + esmtAmt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    },
    ftRoundComma: function(number) {
        if (this.isEmpty(number)) return ''
        else {
            number = Math.round(number);
            return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    },
    ftAllSum: function(spec) {
        let result = 0;
        for (let i = 0; i < spec.length; i++) {
            result = result + (spec[i].orderQty * spec[i].orderUc);
        }
        return "총합계 : " + result.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },

    ftCalcOrderUc: function(esmtUc, orderQty) {
        if (!this.isEmpty(esmtUc) && !this.isEmpty(orderQty)) {
            let esmtReplace = esmtUc.replace(/[^-0-9]/g, '');
            let result = this.fnRoundComma(esmtReplace / orderQty);
            return result;
        } else {
            return '';
        }
    },

    fnRoundComma: function(number) {
        if (this.isEmpty(number)) return ''
        else {
            number = Math.round(number);
            return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
    },

    // 문자열 관련 Utils
    isEmpty: function(str) {
        if (str === "" || str === undefined || str === null || (str !== null && typeof str === "object" && !Object.keys(str).length)) return true;
        else return false;
    },
    defaultIfEmpty: function(str, defaultStr) {
        defaultStr = (this.isEmpty(defaultStr) ? '' : defaultStr);
        return (this.isEmpty(str) ? defaultStr : str);
    },
    lpad: function(str, padLen, padStr) {
        if (padStr.length > padLen) return str;
        str += ""; // 문자로 변환
        padStr += ""; // 문자로 변환
        while (str.length < padLen) str = padStr + str;
        str = str.length >= padLen ? str.substring(0, padLen) : str;
        return str;
    },

    // 날짜 관련 Utils
    getCurretDate: function(format) {
        format = this.defaultIfEmpty(format, 'yyyy-mm-dd');
        return this.formatDate(new Date(), format);
    },
    formatDate: function(date, format) {
        const map = {
            mm: this.lpad(date.getMonth() + 1, 2, '0'),
            dd: this.lpad(date.getDate(), 2, '0'),
            yy: date.getFullYear().toString().slice(-2),
            yyyy: date.getFullYear().toString()
        };
        return format.replace(/mm|dd|yyyy|yy/gi, function(matched) { return map[matched]; });
    },
    strDateAddDay: function(dateStr, interval) {
        const dateParts = dateStr.split('-');
        const sDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);
        sDate.setDate(sDate.getDate() + interval);
        return this.formatDate(sDate, 'yyyy-mm-dd');
    }
};
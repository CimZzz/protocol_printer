const kMaxBytePerLine = 4;


const _undefinedField = Field (
	name: 'none',
	useByteSize: 0,
);

class PrintProtocol {
    const PrintProtocol({this.bytePerLine = kMaxBytePerLine, this.borderCode = '-', this.cornerCode = '+', this.connectorCode = '|', this.separatorCode = '|', this.fillCode = ' ', this.fieldList}):
	    assert(bytePerLine != null && bytePerLine > 0),
	    assert(borderCode != null && borderCode.length == 1),
	    assert(cornerCode != null && cornerCode.length == 1),
	    assert(connectorCode != null && connectorCode.length == 1),
	    assert(separatorCode != null && separatorCode.length == 1),
	    assert(fillCode != null && fillCode.length == 1),
	    contentAreaLength = bytePerLine * 16 + 1,
	    bitPerLine = bytePerLine * 8;

	final int bytePerLine;
    final int bitPerLine;
    final int contentAreaLength;
	final String borderCode;
	final String cornerCode;
	final String connectorCode;
	final String separatorCode;
	final String fillCode;
	final List<Field> fieldList;
	
	String getProtocolInfo() {
		if(fieldList == null || fieldList.isEmpty) {
			return '';
		}
		final buffer = StringBuffer();
		for(final field in fieldList) {
			buffer.writeln(field.getFieldInfo());
		}
		return buffer.toString();
	}
	
	String getProtocolStr() {
		final buffer = StringBuffer();
		_printProtocolHeader(buffer);
		_printProtocolBorder(buffer);
		var remainedBits = bitPerLine;
		if(fieldList == null || fieldList.isEmpty) {
			_printLineStart(buffer);
			_printLineEnd(buffer, remainedBits);
		}
		else {
			var needStart = true;
			var hasMultiLine = false;
			var hasField = false;
			for(final field in fieldList) {
				final fieldUseBitSize = field.useBitSize;
				if(fieldUseBitSize == 0) {
					continue;
				}
				if(fieldUseBitSize > remainedBits) {
					throw Exception('bit not align: ${field.name}');
				}
				if(needStart) {
					needStart = false;
					if(!hasMultiLine) {
						hasMultiLine = true;
					}
					else {
						_printSplitLine(buffer);
					}
					_printLineStart(buffer);
				}
				if(!hasField) {
					hasField = true;
				}
				_printField(buffer, field, fieldUseBitSize * 2 - 1);
				remainedBits -= fieldUseBitSize;
				if(remainedBits == 0) {
					_printLineEnd(buffer, remainedBits);
					remainedBits = bitPerLine;
					needStart = true;
				}
				else {
					buffer.write(separatorCode);
				}
			}
			if(hasField) {
				if(!needStart) {
					_printLineEnd(buffer, remainedBits);
				}
			}
			else if(needStart) {
				_printLineStart(buffer);
				_printLineEnd(buffer, remainedBits);
			}
			
		}
		_printProtocolBorder(buffer);
		return buffer.toString();
	}
	
	void _printProtocolHeader(StringBuffer buffer) {
		buffer.write(' ');
		for(var i = 0 ; i < bytePerLine ; i ++) {
			for(var j = 0 ; j < 8 ; j ++ ) {
				buffer.write(' $j');
			}
		}
		buffer.write('  \n');
	}
	
	void _printProtocolBorder(StringBuffer buffer) {
		buffer.write(cornerCode);
		for(var i = 0 ; i < contentAreaLength ; i ++) {
			buffer.write(i % 2 != 0 ? borderCode : fillCode);
		}
		buffer.write('$cornerCode\n');
	}
	
	void _printLineStart(StringBuffer buffer) {
		buffer.write('$connectorCode ');
	}
	
	void _printSplitLine(StringBuffer buffer) {
		buffer.write('$borderCode');
		for(var i = 0 ; i < contentAreaLength ; i ++) {
			buffer.write(i % 2 != 0 ? borderCode : fillCode);
		}
		buffer.write('$borderCode\n');
	}
	
	void _printLineEnd(StringBuffer buffer, int remainedBits) {
		if(remainedBits > 0) {
			_printField(buffer, _undefinedField, remainedBits * 2 - 1);
		}
		buffer.write(' $connectorCode\n');
	}
	
	void _printField(StringBuffer buffer, Field field, int space) {
		var outputStr = field.name;
		var nameLength = outputStr.codeUnits.length;
		var padding = 0;
		if(nameLength > space) {
			nameLength = space;
			outputStr = outputStr.substring(0, nameLength);
		}
		else {
			padding = (space - nameLength) ~/ 2;
		}
		
		var whiteSpace = padding;
		while(whiteSpace-- > 0) {
			buffer.write(' ');
		}
		
		buffer.write(outputStr);
		
		whiteSpace = space - nameLength - padding;
		while(whiteSpace-- > 0) {
			buffer.write(' ');
		}
	}
}

class Field {
    const Field({this.name, String shortName, this.type, this.info, int useByteSize, int useBitSize}):
	    assert(useByteSize != null || useBitSize != null),
	    useBitSize = useBitSize ?? useByteSize * 8,
        shortName = shortName ?? name;

	final String shortName;
	final String name;
	final String type;
	final String info;
	final int useBitSize;
	
	String getFieldInfo() {
		final useByte = useBitSize >> 3;
		final overByte = useByte << 3 < useBitSize;
		return '$shortName: ${type ?? 'unknown'}, $useBitSize bits ${useByte > 0 ? (overByte ? '( over $useByte bytes )' : '($useByte bytes)') : ''} ${info != null ? ', $info' : ''}';
	}
}
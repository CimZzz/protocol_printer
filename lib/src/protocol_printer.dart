
const kMaxBytePerLine = 4;

class PrintProtocol {
    const PrintProtocol({this.bytePerLine = kMaxBytePerLine, this.borderCode = '-', this.cornerCode = '+', this.connectorCode = '|', this.separatorCode = '|', this.fillCode = ' '}):
	    assert(bytePerLine != null),
	    assert(borderCode != null && borderCode.length == 1),
	    assert(cornerCode != null && cornerCode.length == 1),
	    assert(connectorCode != null && connectorCode.length == 1),
	    assert(separatorCode != null && separatorCode.length == 1),
	    assert(fillCode != null && fillCode.length == 1);

	final int bytePerLine;
	final String borderCode;
	final String cornerCode;
	final String connectorCode;
	final String separatorCode;
	final String fillCode;

	PrintProtocol addType() {

	}
}


class Field {
    const Field({this.shortName, this.name, this.type, this.info, this.useByteSize = 0, this.useBitSize = 0}):
	    assert(shortName != null),
	    assert(useByteSize != null),
	    assert(useBitSize != null),
	    assert(useByteSize != 0 && useBitSize == 0);

	final String shortName;
	final String name;
	final String type;
	final String info;
	final int useByteSize;
	final int useBitSize;

	void buildFormat(StringBuffer buffer, int space, int totalSpace, bool isEnd) {

	}
}
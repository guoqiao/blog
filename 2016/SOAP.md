Title: SOAP Note

Simple Object Access Protocol
Version: 1.2

HTTP + XML = SOAP
SOAP 请求可能是 HTTP POST 或 HTTP GET 请求。
HTTP POST 请求规定至少两个 HTTP 头：Content-Type 和 Content-Length。

Content-Type example:

    POST /item HTTP/1.1
    Content-Type: application/soap+xml; charset=utf-8
    Content-Length: 250

一条 SOAP 消息就是一个普通的 XML 文档，包含下列元素：

- 必需的 Envelope 元素，可把此 XML 文档标识为一条 SOAP 消息
- 可选的 Header 元素，包含头部信息
- 必需的 Body 元素，包含所有的调用和响应信息
- 可选的 Fault 元素，提供有关在处理此消息所发生错误的信息

DOM:

    <?xml version="1.0"?>
    <soap:Envelope
    xmlns:soap="http://www.w3.org/2001/12/soap-envelope"
    soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">

    <soap:Header>
      ...
      ...
    </soap:Header>

    <soap:Body>
      ...
      ...
      <soap:Fault>
        ...
        ...
      </soap:Fault>
    </soap:Body>

    </soap:Envelope>


请注意 xmlns:soap 命名空间的使用。它的值应当始终是：

    http://www.w3.org/2001/12/soap-envelope

如果 Header 元素被提供，则它必须是 Envelope 元素的第一个子元素。

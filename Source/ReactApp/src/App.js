import React, { Component } from 'react';
import './App.css';

class Charsets extends React.Component {
    constructor() {
        super();
        this.state = { 
            value: 0
        };
    }
    onChange = (e) => {
        const {app}=this.props;
        const charset=e.target.value;
        const item=app.state.charsets[charset];
        app.mDo("Charset",item[0],item[1]);
        this.setState({value: charset});
        app.appRef.current.focus();
    }
    render() {
        const {app}=this.props;
        const {charsets}=app.state;
        if (!charsets) return null;
        const elements=charsets.map((item, index) => {
          return (
            <option key={index} value={index}>{item[0]}</option>
          );
        });
        return (
            <select className='charsets' title='Code page' value={this.state.value} onChange={this.onChange}>
            {elements}
            </select>
        );
    }
}

class Tree extends React.Component {
    constructor() {
        super();
        this.treeRef = React.createRef();
        this.tmp = null;
    }

    componentDidMount() {
        window.addEventListener('resize', this.handleResize);
        const {app} = this.props;
        if (app.heightRow == 0) {
            app.heightRow = this.treeRef.current.firstChild.offsetHeight;    
        }
    }

    componentWillUnmount() {
        window.removeEventListener('resize', this.handleResize);
    }

    getClientHeight() {
        //return this.treeRef.current.clientHeight;
        return this.treeRef.current.parentElement.clientHeight;
    }

    handleResize = () => {
        clearTimeout(this.tmp);
        this.tmp = setTimeout(function(){
            const {app} = this.props;
            const i = app.state.selected;
            app.mResize(i);
            return null;
        }.bind(this),250);
    }

    onClick(e) {
        const {app} = this.props;
        const span = e.target; 
        let i=e.currentTarget.id;
        if (span.tagName == "SPAN") {
            if (span.className.indexOf("tree-expanded")!=-1 || span.className.indexOf("tree-collapsed")!=-1) {
                app.mDo("Click",app.state.kolrow,i);
            }
        }
        if (i != app.state.selected) app.setState({selected:i});
        //e.preventDefault();
    }

    onDoubleClick(e) {
        const {app} = this.props;
        //const { data } = this.props;
        const {data} = app.state;
        const span = e.target; 
        let i=e.currentTarget.id;
        const item=data[i-1][2];
        if (span.tagName == "SPAN") {
            if (span.className.indexOf("tree-inden")!=-1) {
                let l=Math.ceil(span.offsetLeft/span.offsetWidth);
                if (item[1]>l) {
                    app.mDo("DClick",i,l);
                }    
            } else if (span.className.indexOf("tree-title")!=-1) {
                let ref=span.innerText.trim();
                if (ref.indexOf(") =")!=-1) ref=ref.split(") =")[0]+")";            app.refs.GoToInput.value=ref;
            }
        }
    }
    render() {
        const { app } = this.props;
        //const { data } = this.props;
        const { data } = app.state;
        const { flexRow } = app;
        const items = [];
        const self = this;
        if (data.length && app.state.kolrow>0) {
            const L=(data.length<app.state.kolrow)?data.length:app.state.kolrow;
            for (let i = 0; i < L; i++) {
                const id=i+1;
                const item=data[i];
                let str = [];
                let classN = "tree-indent";
                for (let i = 1; i < item[2][1]; i++) {
                    str.push(<span className={classN}>&nbsp;</span>);
                }
                if (item[2][0]>=10) { 
                    if (item[2][2]==1) { classN="tree-expanded" }
                    else { classN="tree-collapsed" }
                }
                str.push(<span className={classN}>&nbsp;</span>);
                if (item[2][0]<10) { classN="tree-file" }
                else {
                    if (item[2][2]==1) { classN="tree-folder-open" }
                    else { classN="tree-folder" }
                }
                str.push(<span className={classN}>&nbsp;</span>);
                const node='^'+app.global+'('+item[0]+')'+((item[2][0]%10)?' = '+item[1] :'');
                str.push(<span className="tree-title" title={(app.state.selected == id)?node:""}>&nbsp;
                        {node}
                        </span>);
                classN=(app.state.selected == id) ? "SelectedRow" : "";
                classN=classN+((flexRow)?' flex-fill':'');
                items.push(<li className={classN} key={item[0]} id={id}
                        onClick={self.onClick.bind(self)} 
                        onDoubleClick={self.onDoubleClick.bind(self)} 
                        >{str}</li>);
            }
        } else {
            items.push(<li><span className="tree-indent">&nbsp;</span><span className="tree-title">&nbsp;</span></li>);
        }

        return (
            <ul className={'tree'+((flexRow)?' d-flex':'')} ref={this.treeRef}>
                {items}
            </ul>
        )
    }
}

class App extends React.Component {

    constructor() {
        super();
        this.state = { 
            selected: 1,
            kolrow: 0,
            data: [],
            globals: null,
            charsets: null,
        };
        this.global = '';
        this.heightRow = 0;
        this.appRef = React.createRef();
        this.socket = false;
        this.scr = 0;
        this.downloading = false;
        this.flexRow = false;
        this.tmp = null;
    }
    
    componentDidMount() {
        const app=this.appRef.current;
        app.focus();
        
        let url=window.location.href.split('/')[2];
        /*
        if (url.indexOf(":3000")==-1) {
            url='ws://'+url+'/';
        } else url='ws://192.168.1.81:8080/';
        */
        url='ws://'+url+'/';
        this.ws = new WebSocket(url);

        this.ws.onopen = function() {
            this.socket = true;
            this.mDo("Begin");
        };
        this.ws.onopen = this.ws.onopen.bind(this)

        this.ws.onclose = function() {
            this.socket = false;
            this.global = '';
            this.setState({
                info :'Disconnect',
                data : [],
                globals: null,
                charsets: null,
               });  
        };
        this.ws.onclose = this.ws.onclose.bind(this)

        this.ws.onmessage = function(e) {
            if (e.data) {
                const o=JSON.parse(e.data);
                if (o.fn) this['m'+o.fn].apply(this, o.arg);
            }
        };  
        this.ws.onmessage = this.ws.onmessage.bind(this)

        //app.addEventListener('touchmove', this.onMouseMove.bind(this));
        let f = e => {
            if (this.tmp) {
                clearInterval(this.tmp);
                this.tmp=null;
            }
        }
        window.addEventListener('mouseup', f);
        window.addEventListener('touchend', f);
        f = e => {
            if (this.scr<3 && !this.tmp) {
                let el=e.target;
                if (el.tagName == "SPAN") el=el.parentElement;
                if (el.className.indexOf("SelectedRow")!=-1) {
                    const i=el.id;
                    if (i==1 || i==this.state.kolrow) this.toScroll(i);
                }
            }
        }
        app.addEventListener('mousedown', f);
        app.addEventListener('touchstart', f);
        // Close the dropdown if the user clicks outside of it
        window.addEventListener('click', e => {
            if (!e.target.matches('.dropbtn') && e.target.tagName != "INPUT") {
                    const dropdowns = document.getElementsByClassName("dropdown-content");
                for (let i = 0; i < dropdowns.length; i++) {
                    const openDropdown = dropdowns[i];
                  if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                  }
                }
              }
        });
    }

    byteLength(str) {
        // returns the byte length of an utf8 string
        let s = str.length;
        for (let i=str.length-1; i>=0; i--) {
            const code = str.charCodeAt(i);
            if (code > 0x7f && code <= 0x7ff) s++;
            else if (code > 0x7ff && code <= 0xffff) s+=2;
        }
        return s;
    }
    sendMessage(str) {
        const l=this.byteLength(str);
        const ls=String.fromCharCode(Math.trunc(l/95)%95+32, l%95+32);
	    this.ws.send(String.fromCharCode(126).repeat(4)+ls+str);
    }

    onKeyDown(e) {
        if (!this.state.data.length || e.target.tagName=="INPUT") return null;
        let i=this.state.selected;
        let key=e.key;
        const kol = Math.min(this.state.data.length,this.state.kolrow);
        if (key=="ArrowRight" && e.ctrlKey) {
            this.mDo("CtrlRight",i);
            return null;
        }
        if (key=="+" || key=="ArrowRight" || key=="-" || key=="ArrowLeft") {
            const item=this.state.data[i-1][2];
            if (item[0]>1) { 
                if ((item[2]==1 && (key=="-" || key=="ArrowLeft")) || (item[2]!=1 && (key=="+" || key=="ArrowRight"))) {
                    this.mDo("Click",this.state.kolrow,i);
                    return null;
                }
            }
            if (key=="ArrowLeft" && item[1]>1) {
                this.mDo("Left",i,item[1]);
                return null;
            }
        }
        if (key=="ArrowUp" || key=="ArrowLeft") {
            if (i>1) i--;
            else this.mDo("Key","ArrowUp",i);
        } else if (key=="ArrowDown" || key=="ArrowRight") {
            if (i<kol) i++; 
            else this.mDo("Key","ArrowDown",i);
        } else if (key=="PageUp") {
            if (i>1) i=1;
            else this.mDo("Key",key,i);
        } else if (key=="PageDown") {
            if (i<kol) i=kol; 
            else this.mDo("Key",key,i);
        } else if (key=="Home") {
            if (this.scr<3) this.mDo("Key",key,i);
            i=1;
        } else if (key=="End") {
            if (this.scr<3) this.mDo("Key",key,i);
            i=kol;
        //} else if (key=="Enter") {
        }
        if (this.state.selected!=i) {
            this.setState({ selected: i});
        }
        //e.preventDefault();
    }

    onWheel(e) {
        /*
        if (e.deltaY<0) {
            let e = new KeyboardEvent("keydown", {
                bubbles : true,
                cancelable : true,
                key : "ArrowUp",
                keyCode : 38
            });
            this.appRef.current.dispatchEvent(e);
        } else if (e.deltaY>0) {
            let e = new KeyboardEvent("keydown", {
                bubbles : true,
                cancelable : true,
                key : "ArrowDown",
                keyCode : 40
            });
            this.appRef.current.dispatchEvent(e);
        }
        */
       let i=this.state.selected;
       const kol = Math.min(this.state.data.length,this.state.kolrow);
        if (e.deltaY<0) {
            if (i>1) i--;
            else this.mDo("Key","ArrowUp",i);
        } else if (e.deltaY>0) {
            if (i<kol) i++; 
            else this.mDo("Key","ArrowDown",i);
        }
        if (this.state.selected!=i) {
            this.setState({ selected: i});
        }
    }

    onMouseMove(e) {
        if ((e.type=="touchmove" || (e.type=="mousemove" && e.buttons===1)) && e.target) {
            const to=e.target;
            if (to.tagName == 'LI') {
                if (this.state.selected!=to.id) {
                    if (this.tmp) {
                        clearInterval(this.tmp);
                        this.tmp=null;
                    }
                    this.setState({ selected: to.id}); 
                    return null;
                }
            }
            if (this.scr<3 && !this.tmp) {
                const ul=this.refs.Tree.treeRef.current;
                if (e.clientY<ul.offsetTop) {
                    this.setState({ selected: 1});
                    this.tmp=setInterval(
                        () => this.mDo("Key","ArrowUp",1),
                        100
                    );
                } else if (e.clientY>(ul.offsetTop+ul.offsetHeight)) {
                    const kol=this.state.kolrow;
                    this.setState({selected:kol});
                    this.tmp=setInterval(
                        () => this.mDo("Key","ArrowDown",kol),
                        100
                    );
                }
            }
            e.preventDefault();
        }
    }
    toScroll(i) {
        if (i==1) {
            this.tmp=setInterval(
                () => this.mDo("Key","ArrowUp",1),
                100
            );
        } else {
            this.tmp=setInterval(
                () => this.mDo("Key","ArrowDown",i),
                100
            );
        }
    }
    getKolRow() {
            let kol=Math.trunc(this.refs.Tree.getClientHeight()/this.heightRow);
            // Firefox 1.0+
            if (typeof InstallTrigger !== 'undefined') {
                if ((this.refs.Tree.getClientHeight() % this.heightRow)<Math.trunc(this.heightRow / 2)) kol-=1;
            }
            return kol;
    }

    // GT.M

    mDo() {
        this.sendMessage(JSON.stringify(Array.from(arguments)));
    }
    mBegin(gl,ver,utf) {
        this.setState({
            info: ver,
            globals: gl
        });
        if (utf==0) {
        fetch('/data/charsetData.json')
        .then(response => {
          return response.json()
        })
        .then(data => {
            this.setState({charsets:data});
        })
        }
    }
    mNew(res) {
        if (res>0) {
            const kol = this.getKolRow();
            this.setState({kolrow: kol});
            this.mDo("Reload",'',kol,this.state.selected);
        } else {
            this.global = '';
            this.setState({data: []});
        }
    }
    mResize(i) {
        const kol = this.getKolRow();
        this.setState({kolrow: kol});
        this.mDo("Resize",kol,i);
    }
    mReload(res,kol,i) {
        if (+res==0) {
            this.mDo("Screen",kol);
            this.setState({selected: i});
        } else {
            this.setState({data: []});
        }
    }
    mGoTo(g,kol,i) {
        this.global=g.split('^')[1];
        this.mDo("Screen",kol);
        this.setState({selected: i});
        this.refs.GoToInput.value="";
    }
    mScreen(data,i) {
        this.scr=i;
        if (data.length<this.state.kolrow) this.flexRow = false
        else this.flexRow = true;
	    this.setState({data: data});
    }
    mDownload(file) {
        this.downloading=false;
        this.refs.BtnDownload.disabled=false;
        if (file!=='') {
            const url='http://'+this.ws.url.split('/')[2]+'/';
            window.open(url+file);
        }
    }
    onMenuClick = e => {
        e.currentTarget.nextSibling.classList.toggle("show");
    }
    onGlobalClick = e => {
        const global=e.currentTarget.id;
        this.global=global;
        this.setState({selected: 1});
        this.mDo("New",'^'+global);
        this.appRef.current.focus();
    }
    onGoTo = e => {
        //const input=e.target.previousSibling;
        const input=this.refs.GoToInput;
        const ref=input.value;
        if (ref!="") {
            //input.value="";
            const kol = this.getKolRow();
            this.setState({kolrow: kol});
            this.mDo("GoTo",ref,kol);
            this.appRef.current.focus();
        }
    }
    renderGlobals = () => {
        if (!this.state.globals) return null;
        const globals = this.state.globals.substring(1).split('^');
        const items = [];
        globals.map((item, index) => {
            items.push(
                <button key={item} id={item} className="global" onClick={this.onGlobalClick}>
                {'^'+item}
                </button>
            );
        })
        return (
            <div className="globals dropdown">
            <button className="dropbtn" onClick={this.onMenuClick}>Globals</button>
            <div className="dropdown-content">
                {items}
                <div className="goto"><input ref="GoToInput" type="text" placeholder="Global reference"/>
                <button onClick={this.onGoTo}>Go</button></div>
            </div>
            </div>
        )
    }
    onDownloadClick = e => {
        if (this.global==='') {
            alert('Please select global');
        } else if (this.downloading) {
            alert('Loading in progress...');
        } else {
            this.downloading=true;
            this.refs.BtnDownload.disabled=true;
            this.mDo("Download",(+e.currentTarget.id===1)?this.state.selected:'');
        }
        this.appRef.current.focus();
        e.preventDefault();
    }
    renderDownload = () => {
        if (this.global!='') {
            return (
                <div className="download dropdown">
                <button className="dropbtn" ref="BtnDownload" onClick={this.onMenuClick}>Download</button>
                <div className="dropdown-content">
                <a id="1" href="#download" onClick={this.onDownloadClick}>Current global node</a>
                <a id="2" href="#download" onClick={this.onDownloadClick}>Whole global variable</a>
                </div>
                </div>
            )
        } else return null;
    }
    renderInfo = () => {
        let info2='';
        return (
            <React.Fragment>
            <span className="info">{this.state.info}</span>
            <span className="info2">{info2}</span>
            </React.Fragment>
        )
   }

    render() {
        let result = (
            <React.Fragment>
                <div className="header">
                {this.renderGlobals()}
                <Charsets app={this} />
                {this.renderDownload()}
                </div>
                <div className="main"><Tree ref="Tree" app={this} /></div>
                <div className="footer">{this.renderInfo()}</div>
            </React.Fragment>
            );
        return (
        <div className="app disable-selection" ref={this.appRef} contentEditable={false} tabIndex="0"
         onKeyDown={this.onKeyDown.bind(this)}
         onWheel={this.onWheel.bind(this)}
         onMouseMove={this.onMouseMove.bind(this)}
        >{result}</div>
        );

    }
}

export default App;

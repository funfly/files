var mongoose = require('mongoose')
var Schema = mongoose.Schema;

var serverSchema = Schema({
    ip: String, 
    systemtype: String, 
    release: String,
    totalmem: String,
    cpus: String,
},{versionKey:false})
var Server = mongoose.model('Server', serverSchema);

//CPU: TIME     CPU     %user     %nice   %system   %iowait    %steal     %idle
var cpuStatusSchema = Schema({
    ip: {type:String, index:true},  
    start_time: {type:Date, index:true},
    end_time: {type:Date, index:true},
    time: String, 
    cpu: String,
    user: String,
    nice: String,
    system: String,
    iowait: String,
    steal: String,
    idle: String,
},{versionKey:false});

var CpuStatus = mongoose.model('CpuStatus', cpuStatusSchema);

//内存: TIME      kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
var memStatusSchema = Schema({
    ip: {type:String, index:true},  
    start_time: {type:Date, index:true}, 
    end_time: {type:Date, index:true},
    time: String, 
    kbmemfree: String,
    kbmemused: String,
    memused: String,
    kbbuffers: String,
    kbcached: String,
    kbcommit: String,
    commit: String,
},{versionKey:false});

var MemStatus = mongoose.model('MemStatus', memStatusSchema);

//IO: TIME      tps      rtps      wtps   bread/s   bwrtn/s
var ioStatusSchema = Schema({
    ip: {type:String, index:true},  
    start_time: {type:Date, index:true}, 
    end_time: {type:Date, index:true},
    time: String, 
    tps: String,
    rtps: String,
    wtps: String,
    bread: String,
    bwrtn: String,
},{versionKey:false});

var IoStatus = mongoose.model('IoStatus', ioStatusSchema);

//网络状态: TIME      IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
var netStatusSchema = Schema({
    ip: {type:String, index:true},  
    start_time: {type:Date, index:true}, 
    end_time: {type:Date, index:true},
    time: String, 
    IFACE: String,
    rxpck: String,
    txpck: String,
    rxkB: String,
    txkB: String,
    rxcmp: String,
    txcmp: String,
    rxmcst: String,
},{versionKey:false});

var NetStatus = mongoose.model('NetStatus', netStatusSchema);

//进程队列长度和平均负载: TIME      runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
var loadavgStatusSchema = Schema({
    ip: {type:String, index:true},  
    start_time: {type:Date, index:true}, 
    end_time: {type:Date, index:true},
    time: String, 
    runqSz: String,
    plistSz: String,
    ldavg1: String,
    ldavg5: String,
    ldavg15: String,
},{versionKey:false});

var LoadavgStatus = mongoose.model('LoadavgStatus', loadavgStatusSchema);

exports.connect = function(server) {
    mongoose.connect(server, function (err) {
        if (err) throw err;
    });
}

exports.save = function(schema,data) {
    var model = mongoose.model(schema);
    var entity = new model();
    for(var k in data){
        entity[k] = data[k];
    }
    entity.save(function(err,doc){
        if (err) throw err;
    });
}
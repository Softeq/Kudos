import 'package:rxdart/subjects.dart';
import 'package:semaphore/semaphore.dart';

typedef Future<TResponse> Query<TResponse, TRequest>(TRequest request);

class QueueHandler<TResponse, TRequest> {
  final LocalSemaphore _semaphore = LocalSemaphore(1);
  final PublishSubject<TResponse> _responseSubject =
      PublishSubject<TResponse>();
  final Query<TResponse, TRequest> _query;
  TRequest _latestRequest;

  QueueHandler(this._query);

  Stream<TResponse> get responseStream => _responseSubject;

  void addRequest(TRequest request) async {
    _latestRequest = request;

    await _semaphore.acquire();

    TResponse response;

    if (request == _latestRequest) {
      response = await _query(request);
    } else {
      _semaphore.release();
      return;
    }

    if (request == _latestRequest) {
      _responseSubject.add(response);
    }

    _semaphore.release();
  }

  Future<void> close() async {
    await _responseSubject.close();
  }
}
